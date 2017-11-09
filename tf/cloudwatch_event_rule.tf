resource "aws_cloudwatch_event_rule" "ddb_backup_cloudwatch_event" {
  name        = "ddb_backup_cloudwatch_event"
  event_pattern =<<EVENT
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
       "dynamodb.amazonaws.com"
    ],
  "eventName": [
      "DeleteTable",
      "CreateTable"
    ]
  }
}
EVENT
  role_arn = "${aws_iam_role.ddb_backup_cloudwatch_events_role.arn}"
}

resource "aws_cloudwatch_event_target" "ddb_backup_cloudwatch_event_target" {
  rule = "${aws_cloudwatch_event_rule.ddb_backup_cloudwatch_event.name}"
  arn =  "${var.apex_function_ensure-dynamodb-backups}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "continuous-dynamodb-backup_ensure-dynamodb-backups"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.ddb_backup_cloudwatch_event.arn}"
}
