
output "primary_bucket_website_endpoint" {
  value = aws_s3_bucket.primary.website_endpoint
}

output "backup_bucket_website_endpoint" {
  value = aws_s3_bucket.backup.website_endpoint
}
