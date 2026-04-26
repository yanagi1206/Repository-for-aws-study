resource "aws_security_group" "rds_security_group" {
  name        = "aws-study-sg-rds"
  description = "allow 3306"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "aws-study-sg-rds"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2" {
  security_group_id            = aws_security_group.rds_security_group.id
  referenced_security_group_id = aws_security_group.ec2_security_group.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_ec2" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  identifier             = "aws-study-rds-tf"
  db_name                = "awsstudy"
  engine                 = "mysql"
  engine_version         = "8.0.43"
  instance_class         = "db.t4g.micro"
  username               = data.aws_ssm_parameter.db_username.value
  password               = data.aws_ssm_parameter.db_password.value
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
}

data "aws_ssm_parameter" "db_username" {
  name = "/rds-authentication/rds-username"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/rds-authentication/rds-password"
  with_decryption = true
}

resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.pvtsub1a.id, aws_subnet.pvtsub1c.id]
}