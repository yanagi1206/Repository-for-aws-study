resource "aws_security_group" "ec2_security_group" {
  name        = "aws-study-sg-ec2"
  description = "allow SSH and 8080"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "aws-study-sg-ec2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_home" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "59.168.210.175/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_company" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "159.28.73.98/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id            = aws_security_group.ec2_security_group.id
  referenced_security_group_id = aws_security_group.alb_security_group.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_egrss" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "ec2_instance" {
  ami                         = "ami-088b486f20fab3f0e"
  instance_type               = "t3.micro"
  key_name                    = "new-yanagi-keypair"
  subnet_id                   = aws_subnet.pubsub1a.id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "aws-study-ec2-tf"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami                         = "ami-088b486f20fab3f0e"
  instance_type               = "t3.micro"
  key_name                    = "new-yanagi-keypair"
  subnet_id                   = aws_subnet.pubsub1c.id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "aws-study-ec2-tf"
  }
}