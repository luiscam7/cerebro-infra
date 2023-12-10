// AWS Elastic Map Reduce Serverless Module, required for data analytics

module "emr_serverless" {
  source = "terraform-aws-modules/emr/aws//modules/serverless"

  name = "cerebro-spark"

  release_label_prefix = "emr-6"

  initial_capacity = {
    driver = {
      initial_capacity_type = "Driver"
      initial_capacity_config = {
        worker_count = 2
        worker_configuration = {
          cpu    = "4 vCPU"
          memory = "12 GB"
        }
      }
    }

    executor = {
      initial_capacity_type = "Executor"
      initial_capacity_config = {
        worker_count = 2
        worker_configuration = {
          cpu    = "8 vCPU"
          disk   = "64 GB"
          memory = "24 GB"
        }
      }
    }
  }

  maximum_capacity = {
    cpu    = "48 vCPU"
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
