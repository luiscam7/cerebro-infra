provider "aws" {
  region = var.region

  locals {
    common_tags = {
      Project = "Cerebro"
    }
  }
}







