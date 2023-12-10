// VPC Configuration

resource "aws_vpc" "cerebro_vpc" {
  cidr_block = "10.0.0.0/16" # Define the CIDR block for the VPC

  tags = {
    Name = "Cerebro"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.cerebro_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.cerebro_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id                  = aws_vpc.cerebro_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet3"
  }
}
