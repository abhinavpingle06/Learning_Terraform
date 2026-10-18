terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
  backend "s3" {
    bucket = "tf-buckettest-6eb0281249d96d50"
    key = "backend.tfstate"
    region = "ap-south-1"
  }
}


variable "region" {
  description = "This Holds the region value"
  type = string
  default = "ap-south-1"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "myServer" {
  ami = "ami-01a00762f46d584a1"
  instance_type = var.ec2_type
  tags = {
    Name = "MyServer"
  }
}