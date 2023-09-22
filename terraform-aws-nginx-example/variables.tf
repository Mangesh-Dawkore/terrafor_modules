
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "server_name" {
  type    = string
  default = "nginx_server"
}
variable "region"{
  type = string
  default= "ap-south-1"
}
variable "cidr_block"{
  type = string
  default = "10.0.0.0/16"
}
variable "public_key"{
  type = string
  
}
variable "key_name"{
  type = string
  default = "personal"
}
variable "ami"{
  type = string
  default = "ami-0f5ee92e2d63afc18"
}
variable "instance_name"{
  type = string
  default = "myserver"
}
variable "private_key"{
  type = string
}
variable "sg_name"{
  description = "my_security_group"
  type = string
  default = "sg_my_server"
}
variable "cidr_for_subnet"{
  type = string
  default = "10.0.0.0/24"
}
variable "subnet_AZ"{
  type = string
  default = "ap-south-1a"
}