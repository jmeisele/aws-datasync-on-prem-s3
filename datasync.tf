resource "aws_datasync_location_s3" "staging" {
  s3_bucket_arn = aws_s3_bucket.this.arn
  subdirectory  = "sl1"
  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}

resource "aws_datasync_agent" "this" {
  activation_key = "NIV7E-E90I5-OOOF3-FKLG6-68NG5"
  name           = "jason-mbp"
}

resource "aws_datasync_location_smb" "local_smb" {
  server_hostname = "192.168.1.66"
  subdirectory    = "/50-days-rust"
  user            = "jasoneisele"
  password        = var.password
  agent_arns      = [aws_datasync_agent.this.arn]
}

resource "aws_datasync_task" "xfer_rust" {
  destination_location_arn = aws_datasync_location_s3.staging.arn
  name                     = "xfer_rust"
  source_location_arn      = aws_datasync_location_smb.local_smb.arn
  # schedule {
  #   schedule_expression = "cron(0 12 ? * SUN,WED *)"
  # }
  options {
    bytes_per_second  = -1
    posix_permissions = "NONE"
    uid               = "NONE"
    gid               = "NONE"
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