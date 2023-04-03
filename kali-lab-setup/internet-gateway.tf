resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.kalivpc.id

  tags = {
    Name = var.tags["IG"]
  }
}