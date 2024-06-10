
# Hosts inventory-file

resource "local_file" "hosts" {
    depends_on = [ yandex_compute_instance_group.ig-vm, null_resource.kubespray_cp ]
    content = templatefile("hosts.tftpl", {
        all_nodes = flatten([
            [for v in yandex_compute_instance_group.ig-vm[0].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]],
            [for v in yandex_compute_instance_group.ig-vm[1].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]],
            [for v in yandex_compute_instance_group.ig-vm[2].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]]
        ])
        masters = [for v in yandex_compute_instance_group.ig-vm[0].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]]
        workers = [for v in yandex_compute_instance_group.ig-vm[1].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]]
        ingress = [for v in yandex_compute_instance_group.ig-vm[2].instances : [v.network_interface.0.ip_address, v.network_interface.0.nat_ip_address]]
    })
    filename = "../kubespray/inventory/mycluster/hosts.ini"
}

# On hold

resource "time_sleep" "wait_30s" {
  depends_on = [ resource.local_file.hosts ]
  create_duration = "30s"
}

# Kubespray inventory

resource "null_resource" "kubespray_cp" {
  provisioner "local-exec" {
    command = "cd ../ && cp -rfp kubespray_inventory/. kubespray/inventory/mycluster"
  }
}
resource "null_resource" "kubespray_init" {
  depends_on = [ null_resource.kubespray_cp, time_sleep.wait_30s ]
  provisioner "local-exec" {
    command = "cd ../ && bash kubespray_init.sh"
  }
}

# App apply

resource "null_resource" "app_apply" {
  depends_on = [ null_resource.kubespray_init ]
  provisioner "local-exec" {
    command = "cd ../cicd/netology-app && helm install test-app ./deploy"
  }
}

# Monitoring init

resource "null_resource" "mon_init" {
  depends_on = [ null_resource.app_apply ]
  provisioner "local-exec" {
    command = "cd ../monitoring && bash mon_install.sh"
  }
}
