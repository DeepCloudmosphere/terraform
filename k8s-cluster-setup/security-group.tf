# create security group 

resource "aws_security_group" "k8s-sg" {
  name        = var.sg-name
  description = var.description
  vpc_id      = aws_vpc.k8svpc.id


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

  egress {
    from_port        = 0 # all port
    to_port          = 0 # all port
    protocol         = "-1" # all protocol
    cidr_blocks      = ["0.0.0.0/0"] # any network 
    # ipv6_cidr_blocks = ["::/0"] # any ipv6 cidr 
  }

  tags = {
    Name = var.tags["security-group"]
  }
}
