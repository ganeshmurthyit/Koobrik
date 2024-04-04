module "workspace" {
  source     = "./1.dbWorkspace"
  prefix     = var.prefix
  suffix     = var.suffix
  cidr_block = var.cidr_block
  region     = var.region
  vpcId      = var.vpcId
  databricks_account_id = var.databricks_account_id
  databricks_account_username = var.databricks_account_username
  databricks_account_password = var.databricks_account_password
  AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
}

module "instanceProfile" {
  source = "./12.instanceProfile"
  prefix     = var.prefix
  suffix     = var.suffix
  region     = var.region
  rolename   = module.workspace.role_name
  host           = module.workspace.databricks_host
  token          = module.workspace.databricks_token
  AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
}

/*
module "instancePools" {
  source         = "./2.instancePools"
  prefix         = var.prefix
  suffix         = var.suffix
  host           = module.workspace.databricks_host
  token          = module.workspace.databricks_token
  sparkVersion   = var.sparkVersion
  nodeTypeIdPool = var.nodeTypeIdPool
  workspace      = module.workspace
}

module "high" {
  source              = "./3.dbClusters/high"
  prefix              = var.prefix
  suffix              = var.suffix
  sparkVersionCluster = var.sparkVersionCluster
  host                = module.workspace.databricks_host
  token               = module.workspace.databricks_token
  defaultPoolId       = module.instancePools.defaultPoolId
  workspace           = module.workspace
}

module "sharedCluster" {
  source              = "./3.dbClusters/sharedCluster"
  prefix              = var.prefix
  suffix              = var.suffix
  sparkVersionCluster = var.sparkVersionCluster
  host                = module.workspace.databricks_host
  token               = module.workspace.databricks_token
  defaultPoolId       = module.instancePools.defaultPoolId
  workspace           = module.workspace
}

module "singleNode" {
  source              = "./3.dbClusters/singleNode"
  prefix              = var.prefix
  suffix              = var.suffix
  sparkVersionCluster = var.sparkVersionCluster
  host                = module.workspace.databricks_host
  token               = module.workspace.databricks_token
  nodeTypeIdPool      = var.nodeTypeIdPool
  workspace           = module.workspace
}
*/
module "S3" {
  source                = "./4.s3"
  prefix                = var.prefix
  suffix                = var.suffix
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
}

/*
module "repos" {
  source = "./5.repos"
  host   = module.workspace.databricks_host
  token  = module.workspace.databricks_token
}

module "initScript" {
  source = "./6.globalInitScript"
  host   = module.workspace.databricks_host
  token  = module.workspace.databricks_token
}

module "scopeSecrets" {
  source = "./7.scopeSecrets"
  host   = module.workspace.databricks_host
  token  = module.workspace.databricks_token
}

module "clusterPolicies" {
  source                = "./8.clusterPolicies"
  prefix                = var.prefix
  suffix                = var.suffix
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  host                  = module.workspace.databricks_host
  token                 = module.workspace.databricks_token
}
*/
module "userGroup" {
  source    = "./9.userGroup"
  host      = module.workspace.databricks_host
  token     = module.workspace.databricks_token
  workspace = module.workspace
}
/*
module "jobs" {
  source        = "./10.jobs"
  prefix        = var.prefix
  suffix        = var.suffix
  host          = module.workspace.databricks_host
  token         = module.workspace.databricks_token
  defaultPoolId = module.instancePools.defaultPoolId
  workspace     = module.workspace
}

module "sqlEndpoints" {
  source    = "./11.sqlEndpoints"
  prefix    = var.prefix
  suffix    = var.suffix
  host      = module.workspace.databricks_host
  token     = module.workspace.databricks_token
  workspace = module.workspace
}
*/
module "UnityCatalog" {
  #count = var.create_uc ? 1 : 0
  source = "./UnityCatalog"
  databricks_account_username = var.databricks_account_username
  databricks_account_password = var.databricks_account_password
  databricks_account_id  = var.databricks_account_id
  # databricks_workspace_url = databricks_mws_workspaces.this.workspace_url
  databricks_workspace_url = module.workspace.databricks_host
  workspace_id_uc = module.workspace.workspace_id
  databricks_users   = var.databricks_users
  databricks_metastore_admins = var.databricks_metastore_admins
  tags            = var.tags     
  region = var.region
  AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY  = var.AWS_SECRET_ACCESS_KEY
  unity_admin_group = var.unity_admin_group
  bucket_uc = var.bucket_uc
  cluster_name_uc = var.cluster_name_uc
  name_uc = var.name_uc
  name_catalog = var.name_catalog
  name_schema = var.name_schema
  owner_metastore = var.owner_metastore
  name_metastore = var.name_metastore
  default_catalog_name = var.default_catalog_name
  workspace = module.workspace
  host      = module.workspace.databricks_host
  token     = module.workspace.databricks_token
  # token = var.databricks_token

}
