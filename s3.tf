# Terraform code for configuring s3 buckets


# kage-kowalski-bucket-----------------------------------------------------------------------------------------------------------


# s3 Bucket
resource "aws_s3_bucket" "kage-kowalski-bucket" {
  bucket = "kage-kowalski-bucket"
  tags = var.tags
}


# s3 Bucket ACL
resource "aws_s3_bucket_acl" "kage-kowalski-bucket-acl" {
  bucket = aws_s3_bucket.kage-kowalski-bucket.id
  acl    = "private"
}


# Folders
resource "aws_s3_bucket_object" "kage-kowalski-bucket_test-folder-1" {
  bucket       = aws_s3_bucket.kage-kowalski-bucket.id
  acl          = "private"
  key          = "test-folder-1/"
  content_type = "application/x_directory"
}

