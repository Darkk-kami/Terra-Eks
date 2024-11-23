# IAM Role for Lambda with AssumeRole policy
resource "aws_iam_role" "lambda_role" {
  name = "${var.name}-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}


# IAM Policy for Lambda to access S3, SQS, CloudWatch, and SES
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.name}-lambda-policy"
  description = "Lambda policy for accessing S3, SQS, CloudWatch Logs, and SES"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      # S3 permissions
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      },
      # SQS permissions
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = "${aws_sqs_queue.queue.arn}"
      },
      # CloudWatch permissions
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      # SES permissions
      {
        Effect   = "Allow"
        Action   = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "arn:aws:ses:${var.aws_region}:${var.aws_account_id}:identity/*"
      }
    ]
  })
}


# Attach IAM Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}