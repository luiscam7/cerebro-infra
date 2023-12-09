//Module for S3 resources

resource "aws_s3_bucket" "eeg_datasets_bucket" {
  bucket = "cerebro-eeg-datasets"
  tags = {
    Name = "Cerebro"
  }
}


resource "aws_s3_bucket_ownership_controls" "eeg_datasets_bucket_controls" {
  bucket = aws_s3_bucket.eeg_datasets_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


