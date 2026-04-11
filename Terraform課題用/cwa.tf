resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name        = "Ec2CpuUtilization"
  alarm_description = "Alarted_When_CpuUtilization_Is_Over60%"
  namespace         = "AWS/EC2"
  dimensions = {
    InstanceId = aws_instance.EC2instance.id
  }
  metric_name         = "CPUUtilization"
  unit                = "Percent"
  period              = 300
  statistic           = "Average"
  threshold           = 60
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  treat_missing_data  = "missing"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.sns.id]

}

resource "aws_sns_topic" "sns" {}

resource "aws_sns_topic_subscription" "sns" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "example@gmail.com"
}