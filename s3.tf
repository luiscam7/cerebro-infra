//Module for S3 resources

resource "aws_s3_bucket" "eeg_data_repos_bucket" {
  bucket = "eeg-data-repos"
  tags   = local.common_tags
}

resource "aws_s3_bucket" "eeg_datasets_bucket" {
  bucket = "eeg-datasets"
  tags   = local.common_tags
}