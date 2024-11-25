resource "aws_kms_key" "s3" {
  description             = "S3 bucket KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}