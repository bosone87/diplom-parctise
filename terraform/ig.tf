
# Instance VM group

resource "yandex_compute_instance_group" "ig-vm" {
    depends_on            = [ data.local_file.id_key, yandex_vpc_subnet.public ]
    for_each              = { for key, value in var.ig_vm: key => value }
    name                  = each.value.name
    folder_id             = var.folder_id
    service_account_id    = "${trim("${data.local_file.id_key.content}", "\n")}"
    instance_template {
        name = each.value.name == "master" ? "${"master-{instance.index}"}" : (each.value.name == "worker" ? "${"worker-{instance.index}"}" : "${"ingress-{instance.index}"}")
        platform_id       = each.value.p_id
        resources {
            cores         = each.value.cpu
            memory        = each.value.ram
            core_fraction = each.value.cf
        }
        boot_disk {
            mode          = "READ_WRITE"
            initialize_params {
                image_id  = data.yandex_compute_image.ubuntu.image_id
                size      = each.value.disk
                type      = each.value.type
            }
        }
        network_interface {
            network_id    = yandex_vpc_network.network.id
            subnet_ids    = [ 
                yandex_vpc_subnet.public["sub-a"].id,
                yandex_vpc_subnet.public["sub-b"].id,
                yandex_vpc_subnet.public["sub-d"].id 
                ]
            nat           = each.value.nat
        }
        scheduling_policy {
            preemptible   = each.value.sched_pol
        }
        network_settings {
            type          = "STANDARD"
        }
        metadata          = local.metadata
    }    
    scale_policy {
        fixed_scale {
            size          = each.value.fix_size
        }
    }
    allocation_policy {
        zones             = [ 
                        "${lookup(var.public["sub-a"],"zone")}",
                        "${lookup(var.public["sub-b"],"zone")}",
                        "${lookup(var.public["sub-d"],"zone")}"
        ]
    }
    deploy_policy {
        max_unavailable   = each.value.dep_un
        max_creating      = each.value.dep_create
        max_expansion     = each.value.dep_exp
        max_deleting      = each.value.dep_del
    }
}

resource "yandex_lb_target_group" "lbg-ingress" {
  name       = "lbg-ingress"
  depends_on = [yandex_compute_instance_group.ig-vm[2]]
  dynamic "target" {
    for_each = yandex_compute_instance_group.ig-vm[2].instances
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}