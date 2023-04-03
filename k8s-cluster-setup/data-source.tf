
data "aws_ami" "k8s" {
  most_recent = true
  owners      = ["${var.owners[0]}"]

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
  filter {
    name   = "root-device-type"
    values = ["${var.root-device-type}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization-type}"]
  }
  filter {
    name   = "architecture"
    values = ["${var.architecture}"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
