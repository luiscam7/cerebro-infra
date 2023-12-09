// IAM User, Role, and Policies

resource "aws_iam_policy" "s3_sync_policy" {
  name        = "S3SyncPolicy"
  description = "Policy to allow s3:PutObject and s3:ListBucket for S3 bucket synchronization"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = aws_s3_bucket.eeg_datasets_bucket.arn
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:Sync",
          "s3:CopyObject"
        ],
        Resource = "${aws_s3_bucket.eeg_datasets_bucket.arn}/*"
      }
    ]
  })
}

