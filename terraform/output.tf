output "instance_group_masters_public_ips" {
  description = "Public IP addresses for master-nodes"
  value = yandex_compute_instance_group.ig-vm[0].instances.*.network_interface.0.nat_ip_address
}
output "load_balancer_public_ip" {
  description = "Public IP address of load balancer"
  value = "${[for s in yandex_lb_network_load_balancer.nlb[0].listener: s.external_address_spec.*.address].0[0]}"
}
/* output "instance_group_masters_private_ips" {
  description = "Private IP addresses for master-nodes"
  value = yandex_compute_instance_group.ig-vm[0].instances.*.network_interface.0.ip_address
} */