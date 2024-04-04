resource "aws_s3_bucket" "instanceBucket" {
  bucket = join("", [var.prefix, "-", "instancebucket", "-", var.suffix])
  # region = var.region
  force_destroy = true
  acl    = "private"
}
/*
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.instanceBucket.id
  acl    = "private"
}*/

resource "aws_iam_policy" "assume_role_for_ec2" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "instancebucket-databricks"
    Statement = [
        {  
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.instanceBucket.arn}"
            ],

            "Effect" : "Allow"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            
            "Resource": [
                "${aws_s3_bucket.instanceBucket.arn}"
            ],
            "Effect" : "Allow"
        }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "data_role" {
  name               = join("", [var.prefix, "-", "instancebucketrole", "-", var.suffix])
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
  managed_policy_arns = [aws_iam_policy.assume_role_for_ec2.arn]
}

data "databricks_aws_bucket_policy" "ds" {
  #provider         = databricks.mws
  full_access_role = aws_iam_role.data_role.arn
  bucket           = aws_s3_bucket.instanceBucket.bucket
}

// allow databricks to access this bucket
resource "aws_s3_bucket_policy" "ds" {
  bucket = aws_s3_bucket.instanceBucket.id
  policy = data.databricks_aws_bucket_policy.ds.json
}


data "aws_iam_policy_document" "pass_role_for_s3_access" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.data_role.arn]
  }
}
resource "aws_iam_policy" "pass_role_for_s3_accesss" {
  name   = "shared-pass-role-for-s3-accesss-ucgrants"
  path   = "/"
  policy = data.aws_iam_policy_document.pass_role_for_s3_access.json
}
resource "aws_iam_role_policy_attachment" "cross_account" {
  policy_arn = aws_iam_policy.pass_role_for_s3_accesss.arn
  role       = var.rolename
}
resource "aws_iam_instance_profile" "sharedone" {
  name = join("", [var.prefix, "-", "instancebucketrole", "-", var.suffix])
  role = aws_iam_role.data_role.name
}
resource "databricks_instance_profile" "shared" {
  instance_profile_arn = aws_iam_instance_profile.sharedone.arn
}