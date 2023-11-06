##### data source#######

# ami data source

username = "kali" # for access machine
# username="ubuntu" # for ubuntu access machine
owners = ["679593333241"] # for kali image
# owners=["099720109477"] # for ubuntu image
ami_name = "kali-last-snapshot-amd64-2023.1.0-*" # for kali image name
# ami_name="ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" # for ubuntu image name
root-device-type    = "ebs"
virtualization-type = "hvm"
architecture        = "x86_64"


#### instance configuration #####

instance_type = "t2.medium" # for kali image machine
# instance_type= "t2.micro" # for ubuntu image machine


##### VPC #####
vpc_cidr_block = "192.168.0.0/16"

##### tags ######

tags = {

  ec2             = "kali"
  IG              = "kali-vpc-IG"
  public-key-name = "kali-public-key"
  key-name        = "kali-key"
  route-1-tag     = "kali-public-route"
  route-2-tag     = "kali-private-route"
  security-group  = "kali-sg"
  publicSubnet    = "kali-public-subnet"
  privateSubnet   = "kali-private-subnet"
  vpc_tag         = "kali-vpc"
}

### security group ingress port list
port-list   = [22, 3306, 443, 80]
protocol    = ["tcp", "icmp"]
sg-name     = "kali-sg"
description = "Allow TLS inbound and outbound traffic"




##### public subnet #####

public_cidr_block = "192.168.0.0/24"
map_public_ip     = true

#### private subnet  #####
private_cidr_block = "192.168.1.0/24"
map_public_ip_1    = false
#### provider informtion


region     = "us-east-1" # (ohiao)
access_key = "AKIA5JFZUJV62JZ7TBFA"
secret_key = "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"

