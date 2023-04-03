# create security group 

resource "aws_security_group" "kali-sg" {
  name        = var.sg-name
  description = var.description
  vpc_id      = aws_vpc.kalivpc.id


  dynamic "ingress" {
    for_each = var.port-list
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = var.protocol[0]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # for icmp protocol

  ingress {
    description = "TLS from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = var.protocol[1]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.tags["security-group"]
  }
}
