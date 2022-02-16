# Terraform code for configuring Lambda functions


# clean_s3--------------------------------------------------------------------------------------------------------------


# Zip
data "archive_file" "clean_s3_zip" {
  type             = "zip"
  source_file      = "${path.module}/lambdas/clean_s3.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/lambdas/clean_s3.py.zip"
}


# Lambda
resource "aws_lambda_function" "clean_s3_lambda" {
  filename         = data.archive_file.clean_s3_zip.output_path
  function_name    = "clean_s3"
  handler          = "clean_s3.lambda_handler"
  runtime          = "python3.9"
  timeout          = 10
  role             = aws_iam_role.clean_s3_role.arn
  source_code_hash = data.archive_file.clean_s3_zip.output_base64sha256
  tags             = var.tags
}


# Role
resource "aws_iam_role" "clean_s3_role" {
  name               = "clean_s3_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags               = var.tags
}


# Policy
resource "aws_iam_policy" "clean_s3_policy" {
  name   = "clean_s3_policy"
  policy = data.aws_iam_policy_document.clean_s3_poldoc.json
}


# Policy Document
data "aws_iam_policy_document" "clean_s3_poldoc" {
  statement {
    sid    = ""
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.kage-kowalski-bucket.arn,
    ]
  }
}


# Attach AmazonS3ObjectLambdaExecutionRolePolicy to clean_s3_role
resource "aws_iam_role_policy_attachment" "clean_s3_role-AmazonS3ObjectLambdaExecutionRolePolicy" {
  role       = aws_iam_role.clean_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ObjectLambdaExecutionRolePolicy"
}


# Attach clean_s3_policy to clean_s3_role
resource "aws_iam_role_policy_attachment" "clean_s3_role-clean_s3_policy" {
  role       = aws_iam_role.clean_s3_role.name
  policy_arn = aws_iam_policy.clean_s3_policy.arn
}


# SHARED----------------------------------------------------------------------------------------------------------------


# Create basic Assume Role Policy for Lambdas
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

