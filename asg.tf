module "asg_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.project_name}-asg-sg"
  vpc_id = module.vpc.vpc_id
  description = "ASG - Security group allows only HTTP traffic from ELB"

  computed_ingress_with_source_security_group_id = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Nginx Service Port"
      source_security_group_id = module.elb_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Egress Rules"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Egress Rules"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


resource "aws_cloudwatch_metric_alarm" "elb_sum_requestcount_high" {
    alarm_name = "${var.project_name}-elb-sum-requestcount-high-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    metric_name         = "RequestCount"
    namespace           = "AWS/ELB"
    statistic           = "Sum"
    alarm_description   = "This metric monitors ELB request count with a period of time"
    treat_missing_data  = "missing"

    evaluation_periods  = var.autoscaling_up_alarm_evaluation_periods
    datapoints_to_alarm = var.autoscaling_up_alarm_datapoints_to_alarm
    period = var.autosaling_up_alarm_cloudwatch_alarm_period
    threshold = var.autoscaling_up_alarm_requestcount_target_value

    alarm_actions = [
      aws_autoscaling_policy.asg_autoscaling_policy_up.arn
    ]
    dimensions = {
      LoadBalancerName  = module.elb.elb_name
    }
}

resource "aws_cloudwatch_metric_alarm" "elb_sum_requestcount_low" {
    alarm_name = "${var.project_name}-elb-sum-requestcount-low-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    metric_name         = "RequestCount"
    namespace           = "AWS/ELB"
    statistic           = "Sum"
    alarm_description   = "This metric monitors ELB request count with a period of time"
    treat_missing_data  = "missing"

    evaluation_periods  = var.autoscaling_down_alarm_evaluation_periods
    datapoints_to_alarm = var.autoscaling_down_alarm_datapoints_to_alarm

    period = var.autosaling_down_alarm_cloudwatch_alarm_period
    threshold = var.autoscaling_down_alarm_requestcount_target_value
    alarm_actions = [
      aws_autoscaling_policy.asg_autoscaling_policy_down.arn
    ]
    dimensions = {
      LoadBalancerName  = module.elb.elb_name
    }
}

resource "aws_autoscaling_policy" "asg_autoscaling_policy_up" {
  name = "${var.project_name}-scaling-up-policy"
  autoscaling_group_name  = module.asg.autoscaling_group_name
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = var.autoscaling_event_cooldown
}

resource "aws_autoscaling_policy" "asg_autoscaling_policy_down" {
  name = "${var.project_name}-scaling-down-policy"
  autoscaling_group_name  = module.asg.autoscaling_group_name
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = var.autoscaling_event_cooldown
}

resource "aws_launch_configuration" "asg_launch_conf" {
  name          = "${var.project_name}_asg_launch_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.autoscaling_group_instance_type
  user_data_base64  = filebase64("${path.module}/scripts/launch.sh")
  key_name          = aws_key_pair.deployer.key_name
  security_groups   = [module.asg_sg.security_group_id]
  enable_monitoring = true # Enable detailed monitoring
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "${var.project_name}-asg"

  ### Use the same value as the subnet length to ensure there is at least one instance per zone
  desired_capacity          = local.subnet_length
  min_size                  = local.subnet_length
  max_size                  = local.subnet_length * var.max_instance_per_zone

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"

  vpc_zone_identifier       = module.vpc.private_subnets

  instance_refresh = {
    strategy    = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers    = ["tag"]
  }

  use_lc                = true
  launch_configuration  = aws_launch_configuration.asg_launch_conf.name
  description           = "${var.project_name} - Autoscaling Group"

  enable_monitoring = true
  enabled_metrics   = ["GroupDesiredCapacity", "GroupInServiceCapacity", "GroupPendingCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupStandbyCapacity", "GroupTerminatingCapacity", "GroupTerminatingInstances", "GroupTotalCapacity", "GroupTotalInstances"]

  placement = {
    availability_zone = var.project_region
  }

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.asg.autoscaling_group_name
  elb                    = module.elb.elb_id
}
