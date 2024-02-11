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

resource "aws_s3_bucket" "cerebro_emr_studio_backup" {
  bucket = "cerebro-emr-studio-backup"
  tags = {
    Purpose = "EMR Studio Workspace Backup"
  }
}

resource "aws_s3_bucket_versioning" "cerebro_emr_studio_backup_versioning" {
  bucket = aws_s3_bucket.cerebro_emr_studio_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cerebro_emr_studio_backup_encryption" {
  bucket = aws_s3_bucket.cerebro_emr_studio_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}