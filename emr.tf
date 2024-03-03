// AWS Elastic Map Reduce Serverless Module, required for data analytics

module "emr_serverless" {
  source = "terraform-aws-modules/emr/aws//modules/serverless"

  name = "cerebro-spark"

  release_label_prefix = "emr-6"

  initial_capacity = {
    driver = {
      initial_capacity_type = "Driver"
      initial_capacity_config = {
        worker_count = 1
        worker_configuration = {
          cpu    = "4 vCPU"
          memory = "12 GB"
        }
      }
    }

    executor = {
      initial_capacity_type = "Executor"
      initial_capacity_config = {
        worker_count = 1
        worker_configuration = {
          cpu    = "8 vCPU"
          disk   = "64 GB"
          memory = "24 GB"
        }
      }
    }
  }

  maximum_capacity = {
    cpu    = "16 vCPU"
    memory = "144 GB"
  }

  network_configuration = {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
  }

  security_group_rules = {
    egress_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Cerebro"
  }
}


// Create EMR Studio for interactive analysis

module "emr_studio" {
  source = "terraform-aws-modules/emr/aws//modules/studio"

  name                = "emr-studio-iam"
  auth_mode           = "IAM"
  default_s3_location = "s3://${aws_s3_bucket.cerebro_emr_studio_backup.bucket}/test"

  vpc_id     = aws_vpc.cerebro_vpc.id
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
