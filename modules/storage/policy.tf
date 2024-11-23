# Define a policy for the S3 bucket to control access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:ListBucket",    # Allow listing the bucket's contents
          "s3:GetObject",     # Allow retrieving objects
          "s3:PutObject"      # Allow uploading objects
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",    
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"      # All objects in the bucket
        ],
        Condition = {
          StringEquals = {
            "aws:SourceVpce": var.vpc_endpoint # Restrict access to requests originating from the VPC endpoint
          }
        }
      }
    ]
  })
}



# IAM Role for S3 Replication


# Allows S3 to assume this role for replication purposes
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  # Trust policy allowing S3 to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Grants permissions for source and destination bucket operations during replication
resource "aws_iam_role_policy" "replication_policy" {
  role = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Permissions for reading objects and metadata from the source bucket
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ]
      },
      # Permissions for replicating objects and metadata to the destination bucket
      {
        Effect = "Allow",
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = [
          "arn:aws:s3:::${var.destination_bucket}/*"
        ]
      }
    ]
  })
}