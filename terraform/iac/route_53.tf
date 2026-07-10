resource "aws_route53_zone" "birdswatching_zone" {
  name = "birdswatching.site"
}

module "route_53_reg" {
    source = "../modules/route_53_record"

    zone_id = aws_route53_zone.birdswatching_zone.id
    zone_name = "birdswatching.site"
    domain_name = "birdswatching.site"
    type = "A"
    ttl = "300"
    records = [module.lb_ec2.public_ip]

}

module "route_53_www" {
    source = "../modules/route_53_record"

    zone_id = aws_route53_zone.birdswatching_zone.id
    zone_name = "birdswatching.site"
    domain_name = "www.birdswatching.site"
    type = "A"
    ttl = "300"
    records = [module.lb_ec2.public_ip]
}


output "route_53_name_servers" {
  description = "NS records"
  value       = aws_route53_zone.birdswatching_zone.name_servers
}