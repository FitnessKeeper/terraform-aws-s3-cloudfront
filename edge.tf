# Edge - Route 53 and CloudFront

resource "aws_route53_record" "cloudfront_a" {
  count   = var.cloudfront_fqdn != "" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.cloudfront_fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_aaaa" {
  count   = var.cloudfront_fqdn != "" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.cloudfront_fqdn
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = var.create_bucket ? join("", aws_s3_bucket.bucket.*.bucket_domain_name) : local.bucket_domain_name
    origin_id   = var.create_bucket ? join("", aws_s3_bucket.bucket.*.id) : local.bucket_id
    origin_path = var.cloudfront_origin_path

    s3_origin_config {
      origin_access_identity = var.cloudfront_origin_access_identity_path == "" ? join(
        "",
        aws_cloudfront_origin_access_identity.identity.*.cloudfront_access_identity_path,
      ) : var.cloudfront_origin_access_identity_path
    }
  }

  enabled             = var.cloudfront_enabled
  is_ipv6_enabled     = var.cloudfront_ipv6_enabled
  comment             = var.cloudfront_comment
  default_root_object = var.cloudfront_default_root_object
  aliases = compact(
    distinct(concat([var.cloudfront_fqdn], var.cloudfront_aliases)),
  )
  price_class = var.cloudfront_price_class
  web_acl_id  = var.create_waf_acl ? element(concat(aws_waf_web_acl.cloudfront.*.id, [""]), 0) : ""

  default_cache_behavior {
    allowed_methods        = var.cloudfront_default_cache_allowed_methods
    cached_methods         = var.cloudfront_default_cache_cached_methods
    target_origin_id       = var.create_bucket ? join("", aws_s3_bucket.bucket.*.id) : local.bucket_id
    compress               = var.cloudfront_default_cache_compress
    default_ttl            = var.cloudfront_default_cache_default_ttl
    max_ttl                = var.cloudfront_default_cache_max_ttl
    min_ttl                = var.cloudfront_default_cache_min_ttl
    viewer_protocol_policy = var.cloudfront_default_cache_viewer_protocol_policy

    forwarded_values {
      query_string = var.cloudfront_default_cache_forwarded_values_query_string
      headers      = var.cloudfront_default_cache_forwarded_values_headers

      cookies {
        forward = var.cloudfront_default_cache_forwarded_cookies
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cloudfront.arn
    minimum_protocol_version = var.cloudfront_cert_min_supported_version
    ssl_support_method       = var.cloudfront_cert_ssl_support_method
  }

  tags = var.standard_tags
}

resource "aws_waf_web_acl" "cloudfront" {
  count = var.create_waf_acl ? 1 : 0
  name  = "acl_${var.cloudfront_fqdn}"

  # CloudWatch metric names have strict restrictions on acceptable characters
  metric_name = replace("acl${var.cloudfront_fqdn}", "/[^[:alnum:]]/", "")

  default_action {
    type = var.waf_acl_default_action
  }

  tags = var.standard_tags
}

# outputs from edge tier

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cloudfront.id
}

output "cloudfront_waf_acl_id" {
  value = element(concat(aws_waf_web_acl.cloudfront.*.id, [""]), 0)
}
