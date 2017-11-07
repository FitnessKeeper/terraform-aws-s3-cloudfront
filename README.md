terraform-aws-s3-cloudfront
===========

Terraform module for deploying and managing a CloudFront web distribution backed by an S3 bucket. Also adds Route 53 A records to the CloudFront distribution.

----------------------
#### Required

```
- bucket_name                (name for the S3 bucket to be created)
- s3_region                  (region for the S3 bucket)
- cloudfront_fqdn            (Route 53 record to create to the CloudFront)
- cloudfront_acm_cert_domain (existing ACM Certificate domain to use on CloudFront)
- route53_toplevel_zone      (existing top-level DNS domain for the Route53 record)
```

* Note if you do not want Route 53 records created pointing to the CloudFront distribution you can optionally not pass in `cloudfront_fqdn`. In this case you must specify `cloudfront_aliases` and ensure that the domain to be used for this CloudFront Distribution is allowed in the bucket CORS allowed origins (`bucket_cors_extra_allowed_origins`).

* Note if you do not want to create/manage the S3 bucket (such as for the use case of having multiple CloudFront distributions sourced from different paths of the same S3 bucket), pass `create_bucket = false` (see below for details).

* Note if you do not want this module to create a CloudFront Origin Access Identity, you must pass in `cloudfront_origin_access_identity_path`. If you do still want it to create the S3 bucket, you must also pass in `cloudfront_origin_access_identity_iam_arn` (there is no Terraform AWS provider data source for CloudFront Origin Access Identity, so these can't be looked up).

* Note, if you do not want this module to create the S3 bucket, but you do want it to create the CloudFront Origin Access Identity, it will output `cloudfront_origin_access_identity_path` and `cloudfront_origin_access_identity_iam_arn` so that you can add them to the bucket policy manually.

#### Optional

```
Optional value                                            Default

- create_bucket                                           true
- cloudfront_origin_access_identity_path                  ""
- cloudfront_origin_access_identity_iam_arn               ""
- iam_policy_resources_path                               "/*"
- bucket_acl                                              "private"
- bucket_force_destroy                                    false
- bucket_cors_allowed_headers                             ["*"]
- bucket_cors_extra_allowed_origins                       []
- bucket_cors_expose_headers                              ["ETag"]
- bucket_cors_max_age_seconds                             3000
- cloudfront_origin_path                                  ""
- cloudfront_comment                                      ""
- cloudfront_default_root_object                          "index.html"
- cloudfront_aliases                                      []
- cloudfront_price_class                                  "PriceClass_All"
- cloudfront_default_cache_allowed_methods
                ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
- cloudfront_default_cache_cached_methods                 ["GET", "HEAD"]
- cloudfront_default_cache_compress                       true
- cloudfront_default_cache_default_ttl                    0
- cloudfront_default_cache_max_ttl                        0
- cloudfront_default_cache_min_ttl                        0
- cloudfront_default_cache_viewer_protocol_policy         "redirect-to-https"
- cloudfront_default_cache_forwarded_values_query_string  false
- cloudfront_default_cache_forwarded_cookies              "all"
- cloudfront_geo_restriction_type                         "none"
- cloudfront_cert_min_supported_version                   "TLSv1"
- cloudfront_cert_ssl_support_method                      "sni-only"
- cloudfront_enabled                                      true
- cloudfront_ipv6_enabled                                 true
```

Usage
-----

```hcl

module "static_web" {
  source                            = "github.com/FitnessKeeper/terraform-aws-s3-cloudfront?ref=v0.0.4"
  bucket_name                       = "static-bucket-mydomain"
  s3_region                         = "${data.aws_region.current.name}"
  cloudfront_fqdn                   = "static.mydomain.com"
  cloudfront_acm_cert_domain        = "mydomain.com"
  route53_toplevel_domain           = "mydomain.com"
}
```

* Note if you do not want to create/manage the S3 bucket (such as for the use case of having multiple CloudFront distributions sourced from different paths of the same S3 bucket), set `create_bucket = false`. You will then need to pass in the `cloudfront_origin_access_identity_path` to the one created when you set up your S3 bucket (all CloudFront distributions pointing to this bucket must use same CloudFront Origin Access Identity). You should also setup CORS on the S3 bucket to allow all of the domains for the additional CloudFront distributions.

```hcl

module "static_main" {
  source                            = "github.com/FitnessKeeper/terraform-aws-s3-cloudfront?ref=v0.0.4"
  bucket_name                       = "static-bucket-mydomain"
  cloudfront_origin_path            = "/static_main"
  bucket_cors_extra_allowed_origins = ["*.mydomain.com"]
  s3_region                         = "${data.aws_region.current.name}"
  cloudfront_fqdn                   = "static.mydomain.com"
  cloudfront_acm_cert_domain        = "mydomain.com"
  route53_toplevel_domain           = "mydomain.com"
}

module "static2" {
  source                                 = "github.com/FitnessKeeper/terraform-aws-s3-cloudfront?ref=v0.0.4"
  bucket_name                            = "static-bucket-mydomain"
  cloudfront_origin_path                 = "/static2"
  create_bucket                          = false
  cloudfront_origin_access_identity_path = "${module.static_main.cloudfront_origin_access_identity_path}"
  s3_region                              = "${data.aws_region.current.name}"
  cloudfront_fqdn                        = "static2.mydomain.com"
  cloudfront_acm_cert_domain             = "mydomain.com"
  route53_toplevel_domain                = "mydomain.com"
}

```

Outputs
=======

- cloudfront_origin_access_identity_path
- cloudfront_origin_access_identity_iam_arn
- cloudfront_domain_name
- cloudfront_zone_id

Authors
=======

[John Noss](https://github.com/jnoss)

Changelog
=========

- 0.0.1 - Initial version.
- 0.0.4 - Allow not creating/managing the S3 bucket.

License
=======

This software is released under the MIT License (see `LICENSE`).
