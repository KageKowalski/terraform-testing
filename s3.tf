# Terraform code for configuring s3 buckets


# kage-kowalski-bucket--------------------------------------------------------------------------------------------------


# s3 Bucket
resource "aws_s3_bucket" "kage-kowalski-bucket" {
  bucket = "kage-kowalski-bucket"
  tags = var.tags
}


# Policy + Policy Document
resource "aws_s3_bucket_policy" "kage-kowalski-bucket-policy" {
  bucket = aws_s3_bucket.kage-kowalski-bucket.id
  policy = data.aws_iam_policy_document.kage-kowalski-bucket-poldoc.json
}
data "aws_iam_policy_document" "kage-kowalski-bucket-poldoc" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.clean_s3_role.arn]
    }

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.kage-kowalski-bucket.arn,
      "${aws_s3_bucket.kage-kowalski-bucket.arn}/*"
    ]
  }
}


# Object(s) in bucket
resource "aws_s3_bucket_object" "kage-kowalski-bucket_test-folder-1" {
  bucket       = aws_s3_bucket.kage-kowalski-bucket.id
  acl          = "private"
  key          = "test-folder-1/"
  content_type = "application/x_directory"
}
