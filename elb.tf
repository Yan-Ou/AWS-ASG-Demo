module "elb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 4.2.0"

  name = "${var.project_name}-elb-sg"
  description = "ELB - Security group of ELB that allows only HTTP traffic from everywhere"
  vpc_id      = module.vpc.vpc_id

  # Allow outbound request for installing all dependencies
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "ELB Listening Port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  computed_egress_with_source_security_group_id = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Nginx Service Port"
      source_security_group_id = module.asg_sg.security_group_id
    }
  ]
  number_of_computed_egress_with_source_security_group_id = 1

  tags = local.common_tags
}

module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 3.0"

  name = "${var.project_name}-elb"

  subnets         = module.vpc.public_subnets
  security_groups = [module.elb_sg.security_group_id]

  internal        = false

  listener = [
    {
      instance_port     = 8080
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:8080/"
    interval            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = local.common_tags
}