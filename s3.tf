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

resource "null_resource" "s3-bucket" {

  provisioner "local-exec" {
    command = "aws s3 sync /var/log/httpd/  s3://httpd-log-web/"
  }
}
