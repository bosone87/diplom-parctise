
# Network Load Balancer

resource "yandex_lb_network_load_balancer" "nlb" {
  depends_on        = [ yandex_compute_instance_group.ig-vm, yandex_lb_target_group.lbg-ingress ]
  for_each          = { for key, value in var.nlb_set: key => value }
  name              = each.value.nlb_name
  listener {
    name            = each.value.app_list_name
    port            = each.value.app_port
    target_port     = each.value.app_tport
    external_address_spec {
      ip_version    = "ipv4"
    }
  }
  listener {
    name            = each.value.mon_list_name
    port            = each.value.mon_port
    target_port     = each.value.mon_tport
    external_address_spec {
      ip_version    = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.lbg-ingress.id
    healthcheck {
      name          = each.value.hc_name
      tcp_options {
        port        = each.value.app_tport
      }
    }
  }
}