
variable "owners" {
  type=list
}

variable "ami_name" {
  type=string
}

variable "root-device-type" {
  type=string

}

variable "virtualization-type" {
  type=string
}

variable "architecture" {
  type=string
}




variable "instance_type" {
  type=string
}

variable "tags" {
  type=map
}



variable "region" {
  type=string
}

variable "access_key" {
  type=string
}

variable "secret_key" {
  type=string
}

variable "port-list" {
  type=list

}

variable "protocol" {
  type=list
}

variable "sg-name" {
  type=string
}

variable "description" {
  type=string

}

variable "public_cidr_block" {
  type=string
}

variable "map_public_ip" {
  type=bool
}

variable "private_cidr_block" {
  type=string
}

variable "map_public_ip_1" {
  type=bool
}

variable "vpc_cidr_block" {
  type=string
}

variable "username" {
  type=string
  
}