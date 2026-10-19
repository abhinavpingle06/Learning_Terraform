terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "This Holds the region value"
  type        = string
  default     = "ap-south-1"
}

# Creating my VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf_vpc"
  }
}

# Creating Public Suubnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public_subnet"
  }
}

# Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private_subnet"
  }
}

# Create Internet Gatyeaway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

# Create a Router Table (Its like making our rules)
resource "aws_route_table" "tf_router_table" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "Public_Router"
  }
}

# Create a Router Table Association
resource "aws_route_table_association" "public_routes" {
  route_table_id = aws_route_table.tf_router_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

# Private route table
resource "aws_route_table" "tf_rt_private" {
  vpc_id = aws_vpc.tf_vpc.id
  #   No Routes Assigned
  tags = {
    Name = "Private_Router"
  }
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.tf_rt_private.id
}
