resource "aws_wafv2_web_acl" "waf" {
  name  = "aws-study-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "aws-study-waf"

  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"

    }
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "aws-waf-logs-aws-study"
}

resource "aws_wafv2_web_acl_logging_configuration" "logging_configuration" {
  log_destination_configs = [aws_cloudwatch_log_group.cloudwatch_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.waf.arn
}