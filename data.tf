data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "datasync_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

data "aws_iam_policy_document" "allow_access_from_datasync_role" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }
    actions = [
      "s3:PutBucketAcl"
    ]
    resources = [
      aws_s3_bucket.this.arn
    ]
  }
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.datasync.arn]
    }
    resources = [aws_s3_bucket.this.arn]
  }
  statement {
    sid    = "BucketObjects"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.datasync.arn]
    }
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [aws_s3_bucket.this.arn]
  }
  statement {
    sid    = "BucketObjects"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid    = "Root"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "DataSyncRoleUsage"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/datasync_role"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
}