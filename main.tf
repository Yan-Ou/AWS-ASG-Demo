locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Owner = var.project_name
  }

  subnet_length = length(data.aws_availability_zones.available.names)
  vpc_public_subnets = [for i in range(local.subnet_length) : cidrsubnet(var.base_cidr_block, 8, i+1)]
  vpc_private_subnets = [for i in range(local.subnet_length) : cidrsubnet(var.base_cidr_block, 8, i+101)]
}
