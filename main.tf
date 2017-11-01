# MAIN

provider "aws" {
  alias   = "provided"
  profile = "${var.aws_profile}"
  region  = "${var.region}"
}

data "aws_region" "region" {
  name = "${var.region}"
}

data "aws_route53_zone" "zone" {
  name = "${var.dns_toplevel_zone}."
}

data "aws_acm_certificate" "cert" {
  provider = "aws.provided"
  domain   = "${var.cloudfront_viewer_acm_cert_domain}"
  statuses = ["ISSUED"]
}