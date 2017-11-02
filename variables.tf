variable "aws_profile" {
  type        = "string"
  description = "AWS profile to use when managing resources"
  default     = "default"
}

variable "region" {
  type        = "string"
  description = "AWS region"
}

variable "short_name" {
  description = "Short name to be used for name prefix for backend resources"
  type = "string"
}

variable "bucket_name" {
  description = "Full name for S3 bucket"
  type = "string"
}

variable "cloudfront_fqdn" {
  description = "FQDN for the cloudfront distribution"
  type = "string"
  default = ""
}

variable "dns_toplevel_zone" {
  description = "The top level zone for DNS"
  type        = "string"
}

variable "iam_policy_resources_path" {
  description = "path inside bucket for policy, default /*"
  default = "/*"
}

variable "bucket_acl" {
  default = "private"
}

variable "bucket_force_destroy" {
  default = false
}

variable "bucket_cors_allowed_headers" {
  default = ["*"]
}

variable "bucket_cors_allowed_methods" {
  default = ["GET", "HEAD"]
}

variable "bucket_cors_allowed_origins" {
  type = "list"
}

variable "bucket_cors_expose_headers" {
  type = "list"
  default = ["ETag"]
}

variable "bucket_cors_max_age_seconds" {
  default = 3000
}


# Cloudfront

variable "cloudfront_origin_path" {
  description = "Optional path inside bucket to request resources from"
  default = ""
}

variable "cloudfront_comment" {
  type = "string"
  default = ""
}

variable "cloudfront_default_root_object" {
  default = "index.html"
}

variable "cloudfront_aliases" {
  type = "list"
  default = []
}

variable "cloudfront_price_class" {
  default = "PriceClass_All"
}

variable "cloudfront_default_cache_allowed_methods" {
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cloudfront_default_cache_cached_methods" {
  default = ["GET", "HEAD"]
}

variable "cloudfront_default_cache_compress" {
  default = true
}

variable "cloudfront_default_cache_default_ttl" {
  default = 0
}

variable "cloudfront_default_cache_max_ttl" {
  default = 0
}

variable "cloudfront_default_cache_min_ttl" {
  default = 0
}

variable "cloudfront_default_cache_viewer_protocol_policy" {
  default = "redirect-to-https"
}

variable "cloudfront_default_cache_forwarded_values" {
  default = false
}

variable "cloudfront_default_cache_forwarded_cookies" {
  default = "all"
}

variable "cloudfront_geo_restriction_type" {
  default = "none"
}

variable "cloudfront_viewer_acm_cert_domain" {
  description = "ACM domain to lookup for cert for cloudfront web distribution"
  type = "string"
}

variable "cloudfront_viewer_cert_min_supported_version" {
  default = "TLSv1"
}

variable "cloudfront_viewer_cert_ssl_support_method" {
  default = "sni-only"
}

variable "cloudfront_enabled" {
  default = true
}

variable "cloudfront_ipv6_enabled" {
  default = true
}