# MAIN

provider "aws" {
  alias   = "us-east-1"
}

provider "aws" {
  alias   = "s3"
}

data "aws_region" "us-east-1" {
  name = "us-east-1"
}

data "aws_region" "s3_region" {
  name = var.s3_region
}

data "aws_route53_zone" "zone" {
  name = "${var.route53_toplevel_zone}."
}

data "aws_acm_certificate" "cloudfront" {
  provider    = aws.us-east-1
  domain      = var.cloudfront_acm_cert_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

locals {
  bucket_id          = var.bucket_name
  bucket_domain_name = "${var.bucket_name}.s3.amazonaws.com"
}
