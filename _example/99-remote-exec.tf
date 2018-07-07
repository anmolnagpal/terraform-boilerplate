provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y python",
  ]

  connection {
    user        = "ubuntu"
    private_key = "${file("./../../_ssh/dev-instance-key.pem")}"
    host        = "${self.public_ip}"
  }
}
