resource "aws_vpc" "k8svpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.tags["vpc_tag"]
  }
}