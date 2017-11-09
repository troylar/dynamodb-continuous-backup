provider "aws" {}

variable "aws_region" {
  type = "string"
}

variable "aws_account_id" {
  type = "string"
}

variable "firehose_bucket_name" {
  type = "string"
}

variable "apex_function_ensure-dynamodb-backups" {
  type = "string"
}
