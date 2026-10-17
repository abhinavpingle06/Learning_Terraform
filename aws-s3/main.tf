terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
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

# provider "random" {
# #   FOR NOW EMPTY
# }

resource "random_id" "id_generator" {
  byte_length = 8
}

resource "aws_s3_bucket" "demo_bucket" {
    bucket = "tf-buckettest-${random_id.id_generator.hex}"
}

resource "aws_s3_object" "demo_bucket_obj" {
  bucket = aws_s3_bucket.demo_bucket.bucket
  source = "./hello_world.txt"
  key = "text_hello_world.txt"
}

output "bucket_info" {
  value = aws_s3_bucket.demo_bucket.id
}