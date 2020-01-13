variable "aws_profile" {
  type        = "string"
  description = "AWS profile to use when managing resources"
  default     = "default"
}

variable "bucket_name" {
  description = "Full name for S3 bucket"
  type        = "string"
}

variable "create_bucket" {
  description = "Should this module create and manage this S3 bucket?"
  default     = true
}

variable "cloudfront_origin_access_identity_path" {
  description = "CloudFront origin access identity path to use if not creating the S3 bucket"
  type        = "string"
  default     = ""
}

variable "cloudfront_origin_access_identity_iam_arn" {
  description = "CloudFront origin access identity iam_arn to use in the S3 bucket policy if not creating the CloudFront origin access identity"
  type        = "string"
  default     = ""
}

variable "s3_region" {
  type        = "string"
  description = "AWS region for S3 bucket"
}

variable "cloudfront_fqdn" {
  description = "FQDN for the cloudfront distribution"
  type        = "string"
  default     = ""
}

variable "cloudfront_acm_cert_domain" {
  description = "ACM domain to lookup for cert for cloudfront web distribution"
  type        = "string"
}

variable "route53_toplevel_zone" {
  description = "The top level zone for DNS"
  type        = "string"
}

variable "iam_policy_resources_path" {
  description = "path inside bucket for policy, default /*"
  default     = "/*"
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

variable "bucket_cors_extra_allowed_origins" {
  type    = "list"
  default = []
}

variable "bucket_cors_expose_headers" {
  type    = "list"
  default = ["ETag"]
}

variable "bucket_cors_max_age_seconds" {
  default = 3000
}

# Cloudfront

variable "cloudfront_origin_path" {
  description = "Optional path inside bucket to request resources from"
  default     = ""
}

variable "cloudfront_comment" {
  type    = "string"
  default = ""
}

variable "cloudfront_default_root_object" {
  default = "index.html"
}

variable "cloudfront_aliases" {
  type    = "list"
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

variable "cloudfront_default_cache_forwarded_values_headers" {
  type        = "list"
  description = "List of Headers that you want CloudFront to vary upon for this cache behavior. Specify a single item of '*' to include all headers."
  default     = []
}

variable "cloudfront_default_cache_forwarded_values_query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior."
  default     = false
}

variable "cloudfront_default_cache_forwarded_cookies" {
  default = "all"
}

variable "cloudfront_geo_restriction_type" {
  default = "none"
}

variable "cloudfront_cert_min_supported_version" {
  default = "TLSv1"
}

variable "cloudfront_cert_ssl_support_method" {
  default = "sni-only"
}

variable "cloudfront_enabled" {
  default = true
}

variable "cloudfront_ipv6_enabled" {
  default = true
}

variable "create_waf_acl" {
  default = false
}

variable "waf_acl_default_action" {
  default = "ALLOW"
}
