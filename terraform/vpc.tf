
# Network

resource "yandex_vpc_network" "network" {
  name = var.network_name
}
resource "yandex_vpc_subnet" "public" {
  for_each = var.public
  name           = each.value.name
  zone           = each.value.zone
  v4_cidr_blocks = [ each.value.cidr ]
  network_id     = yandex_vpc_network.network.id
}