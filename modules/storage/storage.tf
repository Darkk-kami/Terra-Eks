# Generate a random suffix for the S3 bucket name to ensure uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create an S3 bucket for EKS application deployment
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "eksclusterappdeployment-${random_id.bucket_suffix.hex}"
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled" 
  }

  depends_on = [aws_s3_bucket.s3_bucket]
}

# Configure replication for the S3 bucket
resource "aws_s3_bucket_replication_configuration" "replication_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "ReplicationRule" 
    status = "Enabled"         

    destination {
      bucket = "arn:aws:s3:::${var.destination_bucket}" # Target bucket for replication
    }

    filter {
      prefix = "" # Replicate all objects (no specific prefix)
    }

    delete_marker_replication {
        status = "Enabled" # Include Delete Marker Replication
      }
    }

  }
