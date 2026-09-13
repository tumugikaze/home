terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
data "aws_caller_identity" "self" {}

resource "aws_s3_bucket" "main" {
  bucket = "${data.aws_caller_identity.self.account_id}-${var.project_name}-bucket"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_acm_certificate" "main" {
  provider    = aws.us_east_1
  domain_name = "tumugikaze.net"

  subject_alternative_names = [
    "*.tumugikaze.net"
  ]

  validation_method = "DNS"
}

output "aws_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "s3_bucket" {
  value = aws_s3_bucket.main.id
}

output "cf_distribution_id" {
  value = aws_cloudfront_distribution.main.id
}

output "acm_dns_validation" {
  value = [
    for dvo in aws_acm_certificate.main.domain_validation_options : {
      domain = dvo.domain_name
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  ]
}
