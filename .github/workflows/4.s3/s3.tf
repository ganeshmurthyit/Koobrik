/*-------------------------------------------------- *
 S3 Buckets *
 The resource block will create all the buckets in the variable array
 *-------------------------------------------------*/
resource "aws_s3_bucket" "dbBucket" {
  bucket = join("", [var.prefix, "-", "dbstoragebucket", "-", var.suffix])
  force_destroy = true
  acl    = "private"
}
/*
resource "aws_s3_bucket_acl" "dbBucket" {
  bucket = aws_s3_bucket.dbBucket.id
  acl    = "private"
}*/

resource "aws_s3_object" "objectSb1" {
  bucket     = aws_s3_bucket.dbBucket.bucket
  key        = "raw"
  depends_on = [aws_s3_bucket.dbBucket]
}

output "bucketId" {
  value = aws_s3_bucket.dbBucket.id
}

output "bucketName" {
  value = aws_s3_bucket.dbBucket.bucket
}
