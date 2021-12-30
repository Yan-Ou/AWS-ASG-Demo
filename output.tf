
output "available_zones" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "elb_url" {
  value = "http://${module.elb.elb_dns_name}"
}

output "private_key_object_id" {
  value = aws_s3_bucket_object.private_key_object.id
}
