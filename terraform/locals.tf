locals {
metadata = {
    serial-port-enable = "1"
    user-data = data.template_file.cloudinit.rendered
}

}