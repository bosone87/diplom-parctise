# DNS recordset

resource "yandex_dns_recordset" "rs" {
    depends_on = [ yandex_compute_instance_group.ig-vm, yandex_lb_target_group.lbg-ingress ]
    for_each   = { for key, value in var.rs: key => value }
    zone_id    = var.bosone_id
    name       = each.value.name
    type       = each.value.type
    ttl        = each.value.ttl
    data       = ["${[for s in yandex_lb_network_load_balancer.nlb[0].listener: s.external_address_spec.*.address].0[0]}"]
    
  }