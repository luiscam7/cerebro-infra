// IAM Roles and Permissions

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  tags = local.common_tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }]
  })
}

resource "aws_iam_policy" "lambda_s3_read_policy" {
  name        = "lambda_s3_read_policy"
  description = "IAM policy for reading S3 bucket"
  tags        = local.common_tags

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Effect = "Allow",
      Resource = [
        "${aws_s3_bucket.eeg_datasets_bucket.arn}",
        "${aws_s3_bucket.eeg_datasets_bucket.arn}/*",
        "${aws_s3_bucket.eeg_data_repos_bucket.arn}",
        "${aws_s3_bucket.eeg_data_repos_bucket.arn}/*"
      ],
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_read_policy.arn
}