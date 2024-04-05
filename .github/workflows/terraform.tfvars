#################### databricks.tf ##########################################################
prefix     = "koobrik"
suffix     = "dev"
cidr_block = "172.31.0.0/16"
region     = "us-east-2"
vpcId      = "vpc-05404eb0af4763dd0"
sparkVersion        = ["11.2.x-scala2.12"]
sparkVersionCluster = "12.2.x-scala2.12"
nodeTypeIdPool      = "t2.micro"

##################################### UnityCatalog ######################################################
databricks_users   = ["jayanth.chinnam@koantek.com"]
databricks_metastore_admins = [ "ganesh.ranganathan@koantek.com", "jayanth.chinnam@koantek.com" ]
unity_admin_group = "koobrikadmin"
bucket_uc = "ucgrantsmetastorebucket"
cluster_name_uc = "koobrik_unity_catalog_cluster"
default_catalog_name = "hive_metastore"
name_uc = "koobrik_unity"
name_catalog = "koobrik_catalog"
name_schema = "koobrik_db"
owner_metastore = "jayanth.chinnam@koantek.com"
name_metastore = "uc_koobrik_meta"