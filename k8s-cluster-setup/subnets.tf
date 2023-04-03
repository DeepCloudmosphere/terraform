resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.k8svpc.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.tags["publicSubnet"]
  }
}

resource "aws_subnet" "privateSubnet" {
  vpc_id                  = aws_vpc.k8svpc.id
  cidr_block              = var.private_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = var.map_public_ip_1

  tags = {
    Name = var.tags["privateSubnet"]
  }
}

