# Data tier - S3

resource "aws_cloudfront_origin_access_identity" "identity" {
  count   = "${(var.cloudfront_origin_access_identity_path == "") ? 1 : 0}"
  comment = "CloudFront access to S3 bucket ${var.bucket_name}"
}

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    sid       = "1"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}${var.iam_policy_resources_path}"]

    principals {
      type        = "AWS"
      identifiers = ["${(var.cloudfront_origin_access_identity_path == "") ? element(concat(aws_cloudfront_origin_access_identity.identity.*.iam_arn, list("")), 0) : var.cloudfront_origin_access_identity_iam_arn}"]
    }
  }

  statement {
    sid       = "2"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${(var.cloudfront_origin_access_identity_path == "") ? element(concat(aws_cloudfront_origin_access_identity.identity.*.iam_arn, list("")), 0) : var.cloudfront_origin_access_identity_iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  count         = "${var.create_bucket ? 1 : 0}"
  provider      = "aws.s3"
  bucket        = "${var.bucket_name}"
  acl           = "${var.bucket_acl}"
  region        = "${data.aws_region.s3_region.name}"
  force_destroy = "${var.bucket_force_destroy}"
  policy        = "${data.aws_iam_policy_document.bucket_policy_document.json}"

  cors_rule {
    allowed_headers = "${var.bucket_cors_allowed_headers}"
    allowed_methods = "${var.bucket_cors_allowed_methods}"
    allowed_origins = ["${compact(distinct(concat(list(var.cloudfront_fqdn), var.cloudfront_aliases, var.bucket_cors_extra_allowed_origins)))}"]
    expose_headers  = "${var.bucket_cors_expose_headers}"
    max_age_seconds = "${var.bucket_cors_max_age_seconds}"
  }
}

# outputs from data tier

output "cloudfront_origin_access_identity_iam_arn" {
  value = "${element(concat(aws_cloudfront_origin_access_identity.identity.*.iam_arn, list("")), 0)}"
}

output "cloudfront_origin_access_identity_path" {
  value = "${element(concat(aws_cloudfront_origin_access_identity.identity.*.cloudfront_access_identity_path, list("")), 0)}"
}
