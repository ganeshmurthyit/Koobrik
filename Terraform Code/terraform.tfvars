#################### databricks.tf ##########################################################
prefix     = "koantek"
suffix     = "democommerceiq"
cidr_block = "10.170.0.0/16"
region     = "ap-south-1"
vpcId      = "vpc-0d5c6de56c79e7a6c"
sparkVersion        = ["11.2.x-scala2.12"]
sparkVersionCluster = "12.2.x-scala2.12"
nodeTypeIdPool      = "m5d.large"

##################################### UnityCatalog ######################################################
databricks_users   = ["sumanth.s.gunasani@koantek.com"]
databricks_metastore_admins = [ "sumanth.s.gunasani@koantek.com", "jayanth.chinnam@koantek.com" ]
unity_admin_group = "CIQadmin"
bucket_uc = "ucgrantsmetastorebucket"
cluster_name_uc = "CIQ_unity_catalog_cluster"
default_catalog_name = "hive_metastore"
name_uc = "CIQ_unity"
name_catalog = "CIQ_catalog"
name_schema = "CIQ_db"
owner_metastore = "karthik@koantek.com"
name_metastore = "uc_CIQ_meta"
