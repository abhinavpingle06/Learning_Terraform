terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "myServer" {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.nano"
  tags = {
    Name = "MyServer"
  }
}