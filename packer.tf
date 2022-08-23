resource "null_resource" "packer" {
  provisioner "local-exec" {
    command = "packer build packer.json"
  }
}
