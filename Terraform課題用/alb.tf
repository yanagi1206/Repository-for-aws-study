resource "aws_security_group" "alb_security_group" {
  name        = "aws-study-sg-alb"
  description = "allow HTTP and HTTPS"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "aws-study-sg-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_internet" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb_target_group" "tg" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path = "/"
    port = 8080
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = [aws_instance.ec2_instance.id, aws_instance.ec2_instance_2.id]
  port             = 8080
}

resource "aws_lb" "alb" {
  security_groups = [aws_security_group.alb_security_group.id]
  subnets         = [aws_subnet.pubsub1a.id, aws_subnet.pubsub1c.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}