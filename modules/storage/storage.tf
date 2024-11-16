resource "random_id" "bucket_suffix" {
  byte_length = 4
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "eksclusterappdeployment-${random_id.bucket_suffix.hex}"
}
