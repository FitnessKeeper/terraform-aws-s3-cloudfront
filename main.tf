# MAIN

provider "aws" {
  alias   = "provided"
  profile = "${var.aws_profile}"
  region  = "us-east-1"
}

data "aws_region" "region" {
  name = "us-east-1"
}

data "aws_route53_zone" "zone" {
  name = "${var.dns_toplevel_zone}."
}

data "aws_acm_certificate" "cert" {
  provider = "aws.provided"
  domain   = "${var.cloudfront_viewer_acm_cert_domain}"
  statuses = ["ISSUED"]
}