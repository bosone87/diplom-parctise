
# Sa key-id file

data "local_file" "id_key" {
  filename = "./id.txt"
}

# Cloud-config

data "template_file" "cloudinit" {
 template = file("./cc.yml")
  vars = {
    ssh_public_key   = file("~/.ssh/id_ed25519.pub")
  }
}

# Image VM

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}