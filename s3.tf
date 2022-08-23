resource "aws_s3_bucket" "example" {
  bucket = "https-log-rizwan"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}


resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example.id
  key    = "httpd"
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}
