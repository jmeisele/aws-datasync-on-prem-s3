resource "aws_s3_bucket" "this" {
  bucket_prefix = "aws-datasync-on-prem-bucket"
  force_destroy = true
}

resource "aws_iam_role" "datasync" {
  name               = "datasync_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.datasync_assume_role_policy.json
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  path        = "/"
  description = "Allows role to interact with bucket"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_policy_attachment" "s3_attachment" {
  name       = "s3-policy-attachment"
  roles      = [aws_iam_role.datasync.name]
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_datasync_location_s3" "staging" {
  s3_bucket_arn = aws_s3_bucket.this.arn
  subdirectory  = "sl1"
  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}

resource "aws_datasync_agent" "this" {
  activation_key = "7J5QL-KCIV9-J698U-L0F8K-U85OF"
  name           = "jason-mbp"
}

resource "aws_datasync_location_smb" "local_smb" {
  server_hostname = "192.168.1.66"
  subdirectory    = "/Users/jasoneisele/Desktop/50-days-rust"
  user            = "jasoneisele"
  password        = var.password
  agent_arns      = [aws_datasync_agent.this.arn]
}

resource "aws_datasync_task" "xfer_rust" {
  destination_location_arn = aws_datasync_location_s3.staging.arn
  name                     = "xfer_rust"
  source_location_arn      = aws_datasync_location_smb.local_smb.arn
  options {
    bytes_per_second  = -1
    posix_permissions = "NONE"
    uid               = "NONE"
  }
  # excludes {
  #   filter_type = "SIMPLE_PATTERN"
  #   value       = "/folder1|/folder2"
  # }
  # includes {
  #   filter_type = "SIMPLE_PATTERN"
  #   value       = "/folder1|/folder2"
  # }
}