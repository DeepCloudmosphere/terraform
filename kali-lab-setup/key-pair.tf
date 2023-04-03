resource "aws_key_pair" "kali-key" {
  key_name   = var.tags["key-name"]
  public_key = file("${path.module}/kali-key.pub")

  tags = {
    Name = var.tags["public-key-name"]
  }
}