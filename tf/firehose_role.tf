resource "aws_iam_policy" "ddb_backup_firehose_policy" {
  name = "ddb_backup_firehose_policy"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.firehose_bucket_name}",
        "arn:aws:s3:::${var.firehose_bucket_name}/*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/kinesisfirehose/*:log-stream:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "ddb_backup_firehose_role" {
  name = "ddb_backup_firehose_role"

  assume_role_policy = <<EOF
{ 
  "Version": "2012-10-17",
   "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "firehose.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
   }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ddb_backup_firehose_policy_attachment" {
  name  = "ddb_backup_firehose_policy_attachment"
  roles = ["${aws_iam_role.ddb_backup_firehose_role.name}"]
  policy_arn = "${aws_iam_policy.ddb_backup_firehose_policy.arn}"
}

output "ddb_firehose_role" {
  value = "${aws_iam_role.ddb_backup_firehose_role.name}"
}
