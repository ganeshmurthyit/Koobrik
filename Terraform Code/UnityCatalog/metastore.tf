resource "databricks_metastore" "this" {
  provider       = databricks.workspace
  name           = var.name_metastore
  storage_root   = "s3://${aws_s3_bucket.metastore.id}/metastore"
  owner          = var.owner_metastore
  force_destroy  = true
}	

resource "databricks_metastore_data_access" "this1" {
  provider     = databricks.workspace
  metastore_id = databricks_metastore.this.id
  name         = aws_iam_role.metastore_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.metastore_data_access.arn
  }
  is_default = true
}

resource "databricks_metastore_assignment" "default_metastore" {
  provider             = databricks.workspace
#  for_each             = toset(var.databricks_workspace_ids)
  workspace_id         = var.workspace_id_uc
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = var.default_catalog_name
}

#metastore Grants
# resource "databricks_grants" "sandbox2" {
#   provider             = databricks.workspace
#   metastore = databricks_metastore.this.id
#   grant {
#     principal  = "admins"
#     privileges = ["CREATE_CATALOG"]
#   }
# }