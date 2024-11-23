# SQS Queue to receive S3 event notifications
resource "aws_sqs_queue" "queue" {
  name = "${var.name}-s3-event"

  # SQS policy to allow messages from the specific S3 bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = "*"
        Condition = {
          "StringEquals" = {
            "aws:SourceArn" = "arn:aws:s3:::${var.s3_bucket_name}"  # Only allow messages from the specified S3 bucket
          }
        }
      }
    ]
  })
}

# S3 Bucket Notification to trigger SQS on object creation
resource "aws_s3_bucket_notification" "event_notification" {
  bucket = var.s3_bucket_name

  # Configure SQS queue as the event destination
  queue {
    queue_arn = aws_sqs_queue.queue.arn
    events    = ["s3:ObjectCreated:*"]  # Trigger on object creation events
  }
}

