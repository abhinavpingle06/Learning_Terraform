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

locals {
  website_files = {
    "index.html" = "./index.html"
    "index.css" = "./index.css"
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

resource "random_id" "id_generator" {
  byte_length = 8
}

resource "aws_s3_bucket" "static_website" {
    bucket = "static-website-tf-${random_id.id_generator.hex}"
}

resource "aws_s3_object" "static_website_files" {
  bucket = aws_s3_bucket.static_website.id
  for_each = local.website_files
  source = each.value
  key = each.key
  etag = filemd5(each.value) #Detects any change in the vlaue files and updates it
  content_type = endswith(each.key, ".html") ? "text/html" : "text/css"
}

resource "aws_s3_bucket_public_access_block" "blocking_perms" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy_perms" {
    bucket = aws_s3_bucket.static_website.id
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "PublicReadGetObject",
            Effect = "Allow",
            Principal = "*",
            Action = "s3:GetObject",
            Resource = "arn:aws:s3:::${aws_s3_bucket.static_website.id}/*"
        }
    ]
})
  
}

resource "aws_s3_bucket_website_configuration" "file_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}


output "bucket_info" {
  value = aws_s3_bucket.static_website.id
}

output "object_info" {
  value = {
    for key, obj in aws_s3_object.static_website_files : 
        key => obj.id
  }
}

output "website_link" {
  value = aws_s3_bucket_website_configuration.file_config.website_endpoint
}