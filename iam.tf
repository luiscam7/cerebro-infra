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

resource "aws_iam_role" "emr_studio_service_role" {
  name = "emr-studio-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "emr_studio_s3_access" {
  name        = "EMRStudioS3Access"
  description = "Policy for EMR Studio role to access cerebro-emr-studio-backup S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::cerebro-emr-studio-backup",
          "arn:aws:s3:::cerebro-emr-studio-backup/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "emr_studio_s3_policy_attachment" {
  role       = aws_iam_role.emr_studio_service_role.name
  policy_arn = aws_iam_policy.emr_studio_s3_access.arn
}
