terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.12.0"
    }
  }
}
provider "aws" {
  region = var.region
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}
resource "aws_instance" "my_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  user_data              = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  subnet_id              = aws_subnet.sub1.id
  tags = {
    Name = var.instance_name
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"              # Replace with the appropriate username for your EC2 instance
    private_key = var.private_key     # Replace with the path to your private key
    host        = self.public_ip
  }
}
resource "aws_security_group" "sg_my_server" {
  name        = var.sg_name
  description = "my_security_group"
  vpc_id      = aws_vpc.main.id

  ingress {

    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_for_subnet
  availability_zone       = var.subnet_AZ
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}