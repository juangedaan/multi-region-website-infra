
provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-east-1"
}

resource "aws_s3_bucket" "primary" {
  bucket = "multi-region-site-primary"
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "backup" {
  provider = aws.secondary
  bucket = "multi-region-site-backup"
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "primary_policy" {
  bucket = aws_s3_bucket.primary.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["s3:GetObject"],
      Effect = "Allow",
      Resource = "${aws_s3_bucket.primary.arn}/*",
      Principal = "*"
    }]
  })
}

resource "aws_s3_bucket_policy" "backup_policy" {
  provider = aws.secondary
  bucket = aws_s3_bucket.backup.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["s3:GetObject"],
      Effect = "Allow",
      Resource = "${aws_s3_bucket.backup.arn}/*",
      Principal = "*"
    }]
  })
}
