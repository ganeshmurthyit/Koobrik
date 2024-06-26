####################################################S3 bucket
resource "aws_s3_bucket" "metastore" {
  bucket = var.bucket_uc
  force_destroy = true
  acl    = "private"
  # tags = merge(var.tags, "${local.prefix}-metastore")
}
/*
resource "aws_s3_bucket_acl" "metastore" {
  bucket = aws_s3_bucket.metastore.id
  acl    = "private"
}*/

resource "aws_s3_bucket_versioning" "metastore" {
  bucket = aws_s3_bucket.metastore.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "metastore" {
  bucket                  = var.bucket_uc
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.metastore]
}

###########################################################################IAM 
data "aws_iam_policy_document" "passrole_for_uc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
}

resource "aws_iam_policy" "unity_metastore" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.name_uc}-databricks-unity-metastore"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          aws_s3_bucket.metastore.arn,
          "${aws_s3_bucket.metastore.arn}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  # tags = merge(var.tags, "${local.prefix}-unity-catalog IAM policy")
}

######################################################################policy for sample data
// Required, in case https://docs.databricks.com/data/databricks-datasets.html are needed
resource "aws_iam_policy" "sample_data" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.name_uc}-databricks-sample-data"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::databricks-datasets-oregon/*",
          "arn:aws:s3:::databricks-datasets-oregon"

        ],
        "Effect" : "Allow"
      }
    ]
  })
  # tags = merge(var.tags, "${local.prefix}-unity-catalog IAM policy")
}

####################################role Iam
resource "aws_iam_role" "metastore_data_access" {
  name = "${var.name_uc}-uc-access"
  assume_role_policy  = data.aws_iam_policy_document.passrole_for_uc.json
  managed_policy_arns = [aws_iam_policy.unity_metastore.arn, aws_iam_policy.sample_data.arn]
  # tags = merge(var.tags, "${local.prefix}-unity-catalog IAM role")
}
