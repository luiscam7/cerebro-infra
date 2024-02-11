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

data "aws_kms_alias" "s3_key" {
  name = "alias/aws/s3"
}

resource "aws_iam_policy" "emr_studio_s3_access" {
  name        = "EMRStudioS3Access"
  description = "Policy for EMR Studio role to access cerebro-emr-studio-backup S3 bucket and use the AWS managed KMS key for S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "ReadAccessForEMRSamples",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::*.elasticmapreduce",
          "arn:aws:s3:::*.elasticmapreduce/*"
        ]
      },
      {
        "Sid" : "FullAccessToCerebroEMRStudioBackupBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::cerebro-emr-studio-backup",
          "arn:aws:s3:::cerebro-emr-studio-backup/*"
        ]
      },
      {
        "Sid" : "KMSAccessForS3Encryption",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : [
          data.aws_kms_alias.s3_key.target_key_arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "emr_studio_s3_policy_attachment" {
  role       = aws_iam_role.emr_studio_service_role.name
  policy_arn = aws_iam_policy.emr_studio_s3_access.arn
}


resource "aws_iam_policy" "emr_studio_user_policy" {
  name        = "EMRStudioUserPolicy"
  description = "Provides access to EMR Studio features"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticmapreduce:DescribeStudio",
          "elasticmapreduce:ListStudios",
          "elasticmapreduce:CreateStudioPresignedUrl",
          "elasticmapreduce:UpdateEditor",
          "elasticmapreduce:PutWorkspaceAccess",
          "elasticmapreduce:DeleteWorkspaceAccess",
          "elasticmapreduce:ListWorkspaceAccessIdentities",
          "emr-containers:ListVirtualClusters",
          "emr-containers:DescribeVirtualCluster",
          "emr-containers:ListManagedEndpoints",
          "emr-containers:DescribeManagedEndpoint",
          "emr-containers:CreateAccessTokenForManagedEndpoint",
          "emr-containers:ListJobRuns",
          "emr-containers:DescribeJobRun",
          "servicecatalog:SearchProducts",
          "servicecatalog:DescribeProduct",
          "servicecatalog:DescribeProductView",
          "servicecatalog:DescribeProvisioningParameters",
          "servicecatalog:ProvisionProduct",
          "servicecatalog:UpdateProvisionedProduct",
          "servicecatalog:ListProvisioningArtifacts",
          "servicecatalog:DescribeRecord",
          "servicecatalog:ListLaunchPaths",
          "cloudformation:DescribeStackResources",
          "sso-directory:SearchUsers",
          "iam:GetUser",
          "iam:GetRole",
          "iam:ListUsers",
          "iam:ListRoles",
          "sso:GetManagedApplicationInstance"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "emr_studio_user_policy_attachment" {
  role       = aws_iam_role.emr_studio_service_role.name
  policy_arn = aws_iam_policy.emr_studio_user_policy.arn
}
