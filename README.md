tf_aws_ecs_service
===========

Terraform module for deploying and managing a CloudFront web distribution backed by an S3 bucket.

----------------------
#### Required

- bucket_name
- bucket_cors_allowed_origins
- cloudfront_fqdn
- dns_toplevel_zone
- cloudfront_viewer_acm_cert_domain
- region
- short_name

#### Optional

Usage
-----

```hcl

module "static_web" {
  source                            = "github.com/terraform-community-modules/tf_aws_s3_cloudfront?ref=v0.0.1"
  region                            = "${data.aws_region.current.name}"
  bucket_name                       = "static-bucket"
  bucket_cors_allowed_origins       = ["static.mydomain.com"]
  cloudfront_fqdn                   = "static.mydomain.com"
  dns_toplevel_zone                 = "mydomain.com"
  cloudfront_viewer_acm_cert_domain = "mydomain.com"
  short_name                        = "static-mydomain"
}
```

Outputs
=======

- S3 bucket domain name
- CloudFront FQDN
- CloudFront A record
- CloudFront S3 bucket source path

Authors
=======

[John Noss](https://github.com/jnoss)

Changelog
=========

0.0.1 - Initial version.

License
=======

This software is released under the MIT License (see `LICENSE`).
