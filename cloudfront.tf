# ------------------------
# Cloudfront cache Distribution
# ------------------------
resource "aws_cloudfront_distribution" "cf" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "cache distribution for s3 bucket"
  price_class     = "PriceClass_All"

  origin {
    domain_name = aws_route53_record.aws_route53_record.fqdn
    origin_id   = aws_lb.alb.name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    target_origin_id       = aws_lb.alb.name
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = ["dev.${var.domain}"]

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.virginia_cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "route53_cloudfront" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = "dev.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = true
  }
}