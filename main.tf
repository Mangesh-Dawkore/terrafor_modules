
provider "aws" {
  region = "ap-south-1"
}

module "nginx" {
  source          = "./terraform-aws-nginx-example"
  instance_type   = "t2.micro"

}

output "public_ip" {
  value = module.nginx.public_ip
}