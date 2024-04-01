####################################################S3 bucket
resource "aws_s3_bucket" "ucexternal" {
  bucket = "ucexternalbucket"
  force_destroy = true
  acl = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.ucexternal.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "ucexternal" {
  bucket                  = "ucexternalbucket"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.ucexternal]
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "ucexternal" {
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
  statement {
    sid     = "ExplicitSelfRoleAssumption"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/externallocation-uc-access"]
    }
  }
}

resource "aws_iam_policy" "ucexternal" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "databricks-unity-externallocation"
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
          aws_s3_bucket.ucexternal.arn,
          "${aws_s3_bucket.ucexternal.arn}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  # tags = merge(var.tags, "${local.prefix}-unity-catalog IAM policy")
}


resource "aws_iam_role" "ucexternal" {
  name = "externallocation-uc-access"
  assume_role_policy  = data.aws_iam_policy_document.ucexternal.json
  managed_policy_arns = [aws_iam_policy.ucexternal.arn]
  # tags = merge(var.tags, "${local.prefix}-unity-catalog IAM role")x`
}


data "databricks_aws_bucket_policy" "ucexternal" {
  #provider         = databricks.mws
  full_access_role = aws_iam_role.ucexternal.arn
  bucket           = aws_s3_bucket.ucexternal.bucket
}

// allow databricks to access this bucket
resource "aws_s3_bucket_policy" "ucexternal" {
  bucket = aws_s3_bucket.ucexternal.id
  policy = data.databricks_aws_bucket_policy.ucexternal.json
}

resource "databricks_storage_credential" "external" {
  provider           = databricks.workspace
  name = aws_iam_role.ucexternal.name
  aws_iam_role {
    role_arn = aws_iam_role.ucexternal.arn
  }
  comment = "Managed by TF"
}

/*
resource "databricks_grants" "external_creds" {
  provider           = databricks.workspace
  storage_credential = databricks_storage_credential.external.id
  grant {
    principal  = "Devops"
    privileges = ["ALL_PRIVILEGES", "CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
  }
}




#ExternalLocation

resource "databricks_external_location" "some" {
  provider        = databricks.workspace
  name            = "external"
  url             = "s3://${aws_s3_bucket.ucexternal.id}/some"
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
}

resource "databricks_grants" "some" {
  provider           = databricks.workspace
  external_location = databricks_external_location.some.id
  grant {
    principal  = "Devops"
    privileges = ["ALL_PRIVILEGES", "CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
  }
}

*/