resource "aws_iam_role" "default" {
  name = var.iam_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_policy" "default" {
  name = var.iam_name
  path = "/"
  description = "Policy for EC2 instance have read, write, and list permissions for our S3 buckets."
  policy = data.aws_iam_policy_document.gitlab_role_policy.json
}

data "aws_iam_policy_document" "gitlab_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:CompleteMultipartUpload",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl" 
    ]
    resources = [
      "arn:aws:s3:::gl-*/*"
    ]
  }
}

