terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "xxx-tf-state"
    key    = "terraform-states/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.project_region

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

