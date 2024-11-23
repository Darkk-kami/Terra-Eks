# Output the name of the S3 bucket created by the terraform configuration
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}
