resource "aws_s3_bucket" "backend_bucket" {
  bucket              = "terraform-backend-bucket-voting-app"
  object_lock_enabled = true

  tags = {
    Name = "terraform-backend-bucket-voting-app"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_restriction" {
  bucket = aws_s3_bucket.backend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
