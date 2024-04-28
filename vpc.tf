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

resource "aws_route_table" "cerebro_route_table" {
  vpc_id = aws_vpc.cerebro_vpc.id

  // Default route for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cerebro_gw.id
  }

  // If IPv6 is enabled and needed
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.cerebro_gw.id
  }

  tags = {
    Name = "cerebro-route-table"
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.cerebro_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.cerebro_route_table.id
}

resource "aws_route_table_association" "subnet3_association" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.cerebro_route_table.id
}

resource "aws_internet_gateway" "cerebro_gw" {
  vpc_id = aws_vpc.cerebro_vpc.id

  tags = {
    Name = "cerebro-gateway"
  }
}