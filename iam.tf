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