# Input variable definitions

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}



data "aws_caller_identity" "current" {}
