variable "project_name" {
  type        = string
  description = "Project name that will be used for resource names and tags"
  default     = "ot8-test"
}

variable "project_region" {
  type        = string
  description = "Project region that will be used for this project"
  default     = "ap-southeast-2"
}

variable "base_cidr_block" {
  type        = string
  description = "Base CIDR of VPC"
  default     = "10.0.0.0/16"
}

variable "terraform_state_s3_bucket" {
  type        = string
  description = "The S3 bucket for storing terraform state file and private key"
  default     = "xxx-tf-state"
}

variable "max_instance_per_zone" {
  type        = number
  description = "The maximum instance number per zone"
  default     = 10
}

variable "autosaling_up_alarm_cloudwatch_alarm_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied."
  default     = 60
}

variable "autoscaling_up_alarm_requestcount_target_value" {
  type        = number
  description = "The value against which the specified statistic is compared for scaling up"
  default     = 20
}

variable "autoscaling_up_alarm_datapoints_to_alarm" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the alarm."
  default     = 1
}

variable "autoscaling_up_alarm_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 1
}

variable "autosaling_down_alarm_cloudwatch_alarm_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied."
  default     = 60
}

variable "autoscaling_down_alarm_requestcount_target_value" {
  type        = number
  description = "The value against which the specified statistic is compared for scaling down"
  default     = 5
}

variable "autoscaling_down_alarm_datapoints_to_alarm" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the alarm."
  default     = 1
}

variable "autoscaling_down_alarm_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 1
}

variable "autoscaling_event_cooldown" {
  type        = number
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = 300
}

variable "autoscaling_estimated_instance_warmup" {
  type        = string
  description = "The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics."
  default     = "60"
}

variable "autoscaling_group_instance_type" {
  type        = string
  description = "The instnace type of autoscaling group"
  default     = "t2.micro"
}

variable "private_key_filename" {
  type        = string
  description = "The filename of newly generated private key"
  default     = "private-key.pem"
}
