variable "databricks_account_username" {
  default = ""
}

variable "databricks_account_password" {
  default = ""
}

variable "workspace" {
  default = ""
}

variable "tags" {
  default = ""
}



variable "databricks_account_id" {
  default = ""
}

variable "databricks_workspace_url" {
  default = ""
}

variable "region" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}


variable "workspace_id_uc" {
  default        = ""
}

variable "databricks_users" {
  description = <<EOT
  List of Databricks users to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.last@domain.com", "second.last@domain.com"]
  EOT
  type        = list(string)
  default = [ "sumanth.s.gunasani@koantek.com", "pankaj.wani@koantek.com" ]
}

variable "databricks_metastore_admins" {
  description = <<EOT
  List of Admins to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.admin@domain.com", "second.admin@domain.com"]
  EOT
  type        = list(string)
  default = [ "sumanth.s.gunasani@koantek.com", "jayanth.chinnam@koantek.com" ]
}

variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
  default     = ""
}

variable "bucket_uc" {
  default = ""
}

variable "acl_uc" {
  default = ""
}

variable "cluster_name_uc" {
  default = ""
}

variable "default_catalog_name" {
  default = ""
}

variable "name_uc" {
  default = ""
}

variable "name_catalog" {
  default = ""
}

variable "name_schema" {
  default = ""
}

variable "name_metastore" {
  default = ""
}

variable "owner_metastore" {
  default = ""
}



# variable "databricks_token" {
#   default = ""
# }


variable "host" {
  default = ""
}
variable "token" {
  default = ""
}
