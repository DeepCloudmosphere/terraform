
resource "aws_instance" "s1" {
  ami                    = data.aws_ami.kali.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.kali-key.key_name
  vpc_security_group_ids = ["${aws_security_group.kali-sg.id}"]
  subnet_id              = aws_subnet.publicSubnet.id
  count                  = 3


  # connection {
  #     type     = "ssh"
  #     user     = var.username
  #     private_key = file("${path.module}/kali-key")
  #     host     = "${self.public_ip}"
  # }

  # provisioner "remote-exec" {
  #   script = "${path.module}/install.sh"
  # }

  tags = {
    Name = var.tags["ec2"]
  }
}


output "URL" {
  value = "You can access by:-> \n\n##################\n\nsudo ssh -i 'kali-key' ${var.username}@${aws_instance.s1.public_ip}\n\n##################\n\n'"
}