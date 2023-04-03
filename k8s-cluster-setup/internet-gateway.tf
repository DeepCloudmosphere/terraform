resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.k8svpc.id

  tags = {
    Name = var.tags["IG"]
  }
}