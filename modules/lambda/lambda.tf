# Archive Lambda source code
data "archive_file" "lambda_event" {
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/lambda.zip"
  type        = "zip"
}

# Define Lambda function
resource "aws_lambda_function" "function" {
  filename         = data.archive_file.lambda_event.output_path
  source_code_hash = data.archive_file.lambda_event.output_base64sha256
  function_name    = "${var.name}-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "python3.12"

  environment {
    variables = {
      SES_SOURCE_EMAIL     = var.email
      SES_DESTINATION_EMAIL = var.email
    }
  }
}

# Trigger Lambda from SQS
resource "aws_lambda_event_source_mapping" "event_source" {
  event_source_arn = aws_sqs_queue.queue.arn
  enabled          = true
  function_name    = aws_lambda_function.function.arn
  batch_size       = 1
}