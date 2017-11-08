resource "aws_iam_policy" "ddb_backup_lambda_policy" {
  name = "ddb_backup_lambda_policy"
  path = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1444729748000",
            "Effect": "Allow",
            "Action": [
                "firehose:CreateDeliveryStream",
                "firehose:DescribeDeliveryStream",
                "firehose:ListDeliveryStreams",
                "firehose:PutRecord",
                "firehose:PutRecordBatch",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:ListStreams",
                "dynamodb:ListTables",
                "dynamodb:UpdateTable",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "lambda:GetFunction",
                "lambda:CreateFunction",
                "lambda:CreateEventSourceMapping",
                "lambda:ListEventSourceMappings",
                "iam:passrole",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "ddb_backup_lambda_role" {
  name = "ddb_backup_lambda_role"

  assume_role_policy = <<EOF
{ 
  "Version": "2012-10-17",
   "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
   }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ddb_backup_lambda_policy_attachment" {
  name  = "ddb_backup_lambda_policy_attachment"
  roles = ["${aws_iam_role.ddb_backup_lambda_role.name}"]
  policy_arn = "${aws_iam_policy.ddb_backup_lambda_policy.arn}"
}

output "ddb_backup_lambda_role" {
  value = "${aws_iam_role.ddb_backup_lambda_role.name}"
}
