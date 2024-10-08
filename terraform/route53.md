### route53.tf

# route53.tf
# route53.tf

# Create a Route53 Hosted Zone
resource "aws_route53_zone" "shredder_zone" {
  name = var.domain_name
}

# Create a Route53 Record pointing to the existing ALB
resource "aws_route53_record" "shredder_record" {
  zone_id = aws_route53_zone.shredder_zone.zone_id
  name    = var.route53_record_name
  type    = "A"

  alias {
    name                   = aws_lb.shredder_alb.dns_name
    zone_id                = aws_lb.shredder_alb.zone_id
    evaluate_target_health = true
  }
}
