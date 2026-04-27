run "vpc_test" {
  command = plan

  assert {
    condition     = aws_vpc.vpc.cidr_block == "10.0.0.0/16"
    error_message = "CIDRが違う"
  }

  assert {
    condition     = aws_vpc.vpc.enable_dns_support == true
    error_message = "DNS supportが無効"
  }

  assert {
    condition     = aws_vpc.vpc.enable_dns_hostnames == true
    error_message = "DNS hostnamesが無効"
  }

  assert {
    condition = aws_subnet.pubsub1a.availability_zone == "ap-northeast-1a"
    error_message = "AZが違う"
  }

  assert {
    condition = aws_subnet.pubsub1c.availability_zone == "ap-northeast-1c"
    error_message = "AZが違う"
  }

  assert {
    condition = aws_subnet.pvtsub1a.availability_zone == "ap-northeast-1a"
    error_message = "AZが違う"
  }

  assert {
    condition = aws_subnet.pvtsub1c.availability_zone == "ap-northeast-1c"
    error_message = "AZが違う"
  }
}