
resource "aws_instance" "s2" {
  ami                    = data.aws_ami.k8s.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s-key.key_name
  vpc_security_group_ids = ["${aws_security_group.k8s-sg.id}"]
  subnet_id              = aws_subnet.publicSubnet.id

  connection {
    type        = "ssh"
    user        = var.username
    private_key = file("${path.module}/k8s-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/cluster-node.sh"
  }

  tags = {
    Name = "K8S-NODE"
  }
}


resource "aws_instance" "s1" {
  ami                    = data.aws_ami.k8s.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s-key.key_name
  vpc_security_group_ids = ["${aws_security_group.k8s-sg.id}"]
  subnet_id              = aws_subnet.publicSubnet.id

  connection {
    type        = "ssh"
    user        = var.username
    private_key = file("${path.module}/k8s-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/cluster-node.sh"
  }

  provisioner "file" {
    source      = "master.sh"
    destination = "/tmp/master.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/master.sh",
      "sudo /tmp/master.sh ${aws_instance.s2.private_ip}",
    ]
  }


  tags = {
    Name = var.tags["ec2"]
  }
}

output "URL" {
  value = "You can access by:-> \n\n##################\n\nsudo ssh -i 'k8s-key' ${var.username}@${aws_instance.s1.public_ip}\n\n##################\n\n'"
}