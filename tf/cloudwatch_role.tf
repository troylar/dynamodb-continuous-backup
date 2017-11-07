data "aws_iam_policy_document" "ddb_backup_policy_document" {
  statement {
    sid = "CloudWatchEventsInvocationAccess"
    effect = "Allow"
    actions = [
      "kinesis:PutRecord"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ddb_backup_policy" {
  name = "ddb_backup_policy"
  path = "/"
  policy = "${data.aws_iam_policy_document.ddb_backup_policy_document.json}"
}

resource "aws_iam_role" "dynamodb_backup_role" {
  name = "dynamodb_backup_role"

  assume_role_policy = <<EOF
{ 
  "Version": "2012-10-17",
   "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "events.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
   }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ddb_backup_policy_attachment" {
  name  = "ddb_backup_policy_attachment"
  roles = ["${aws_iam_role.dynamodb_backup_role.name}"]
  policy_arn = "${aws_iam_policy.ddb_backup_policy.arn}"
}

output "ddb_role" {
  value = "${aws_iam_role.dynamodb_backup_role.name}"
}
