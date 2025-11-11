resource "aws_instance" "web_with_provisioner" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "your-key-pair"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  provisioner "file" {
    source      = "install_apache.sh"
    destination = "/tmp/install_apache.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/your-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "sudo /tmp/install_apache.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/your-key.pem")
      host        = self.public_ip
    }
  }
}
