resource "aws_route_table" "route-1" {
  vpc_id = aws_vpc.kalivpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.tags["route-1-tag"]
  }
}


resource "aws_route_table" "route-2" {
  vpc_id = aws_vpc.kalivpc.id

  tags = {
    Name = var.tags["route-2-tag"]
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicSubnet.id # public subnet
  route_table_id = aws_route_table.route-1.id # public-route
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.privateSubnet.id # private subnet
  route_table_id = aws_route_table.route-2.id  # private route
}
