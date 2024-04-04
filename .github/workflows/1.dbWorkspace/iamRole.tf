data "databricks_aws_assume_role_policy" "thisiam" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = join("", [var.prefix, "-", "crossaccounts",  "-", var.suffix])
  assume_role_policy = data.databricks_aws_assume_role_policy.thisiam.json
  # tags             = join("", [var.prefix, "-", "project", "-", var.suffix])
}

data "databricks_aws_crossaccount_policy" "thiscr" {
}

resource "aws_iam_role_policy" "thispl" {
  name   = join("", [var.prefix, "-", "policy", "-", var.suffix])
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.thiscr.json
}


resource "databricks_mws_credentials" "thiscred" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = join("", [var.prefix, "-", "creds", "-", var.suffix])
  depends_on       = [aws_iam_role_policy.thispl,time_sleep.wait]
}
resource "time_sleep" "wait" {
  depends_on = [
    aws_iam_role.cross_account_role
  ]
  create_duration = "130s"
}

output "role_name" {
  value = aws_iam_role.cross_account_role.name
}