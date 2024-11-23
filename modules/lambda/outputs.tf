output "lambda_function_arn" {
  value = aws_lambda_function.function.arn
}

output "s3_bucket_configuration" {
  value = aws_s3_bucket_notification.event_notification.id
}
