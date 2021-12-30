module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = var.base_cidr_block
  azs  = data.aws_availability_zones.available.names
  tags = local.common_tags

  # public subnet
  public_subnets = local.vpc_public_subnets
  public_subnet_suffix  = "-public"
  public_subnet_tags = merge(local.common_tags, {
    SubnetType  = "public"
  })
  public_route_table_tags = merge(local.common_tags, {
    RouteTableType  = "public"
  })
  propagate_public_route_tables_vgw = true

  # private subnet
  private_subnets  = local.vpc_private_subnets
  private_subnet_suffix = "-private"
  private_subnet_tags = merge(local.common_tags, {
    SubnetType  = "private"
  })
  private_route_table_tags = merge(local.common_tags, {
    RouteTableType  = "private"
  })
  propagate_private_route_tables_vgw = true

  enable_vpn_gateway = false
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
}