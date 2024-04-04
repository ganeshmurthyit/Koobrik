resource "databricks_mws_workspaces" "this" {
  provider       = databricks.mws
  account_id     = var.databricks_account_id
  aws_region     = var.region
  workspace_name = join("", [var.prefix, "-", "-dbws-", "-", var.suffix])// Workspace Name 

  credentials_id           = databricks_mws_credentials.thiscred.credentials_id // credential id passed by using API
  storage_configuration_id = databricks_mws_storage_configurations.thisstrg.storage_configuration_id
  network_id               = databricks_mws_networks.thisNet.network_id

  token {
    comment = "Terraform"
  }
}

output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}

output "databricks_token" {
  value     = databricks_mws_workspaces.this.token[0].token_value
  sensitive = true
}

output "workspace_id" {
  value = databricks_mws_workspaces.this.workspace_id  
}
