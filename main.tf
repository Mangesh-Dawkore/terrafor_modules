
provider "aws" {
  region = "ap-south-1"
}

module "nginx" {
  source          = "./terraform-aws-nginx-example"
  instance_type   = "t2.micro"   # Replace with your need
  public_key      = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key
  private_key     = file("~/.ssh/id_rsa")   # Replace with the path to your private key
  server_name     = "nginx_server"    # Replace with your server name
  region          = "ap-south-1"    # choose your region
  cidr_block      = "10.0.0.0/16"    # replace with your prefered value
  key_name        = "personal"        # Replace with the key name
  ami             = "ami-0f5ee92e2d63afc18"  # choose your ami and replace it
  instance_name   = "myserver"           # Replace with your server name
  sg_name         = "sg_my_server"  # Replace with your security group name
  cidr_for_subnet = "10.0.0.0/24"    # Replace with your cidr value
  subnet_AZ       = "ap-south-1a"   # Replace with your subnet avalibility zone
}

output "public_ip" {
  value = module.nginx.public_ip
}