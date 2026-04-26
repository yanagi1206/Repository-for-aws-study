resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-study-vpc-tf"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "aws-study-igw-tf"
  }
}

resource "aws_subnet" "pubsub1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-study-subnet-public-1a"
  }
}

resource "aws_subnet" "pubsub1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "aws-study-subnet-public-1c"
  }
}

resource "aws_subnet" "pvtsub1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-study-subnet-private-1a"
  }
}

resource "aws_subnet" "pvtsub1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "aws-study-subnet-private-1c"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aws-study-public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "aws-study-private_route_table"
  }
}

resource "aws_route_table_association" "public1a" {
  subnet_id      = aws_subnet.pubsub1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public1c" {
  subnet_id      = aws_subnet.pubsub1c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private1a" {
  subnet_id      = aws_subnet.pvtsub1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private1c" {
  subnet_id      = aws_subnet.pvtsub1c.id
  route_table_id = aws_route_table.private_route_table.id
}