resource "aws_key_pair" "k8s-key" {
  key_name   = var.tags["key-name"]
  public_key = file("${path.module}/k8s-key.pub")

  tags = {
    Name = var.tags["public-key-name"]
  }
}