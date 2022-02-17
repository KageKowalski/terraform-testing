# Terraform and provider configuration data


# Declare variables
variable "tags" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "clean_s3_poldoc_resources" {
  description = "Buckets that clean_s3_role has access to"
  type        = list(string)
  default     = []
}


# Terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}


# AWS configuration
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

