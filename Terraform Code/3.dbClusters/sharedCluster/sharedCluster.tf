resource "databricks_cluster" "sharedAutoScaling" {
  cluster_name            = join("", [var.prefix, "-", "sharedCluster", "-", var.suffix])
  spark_version           = var.sparkVersionCluster
  instance_pool_id        = var.defaultPoolId
  driver_instance_pool_id = var.defaultPoolId
  autotermination_minutes = 20
  autoscale {
    min_workers = "1"
    max_workers = "2"
  }
  spark_conf = {
    "spark.databricks.io.cache.enabled" : true,
    "spark.databricks.io.cache.maxDiskUsage" : "50g",
    "spark.databricks.io.cache.maxMetaDataCache" : "1g",
    "spark.databricks.repl.allowedLanguages" : "python,sql,scala",
    "spark.databricks.delta.preview.enabled" : true,
    "spark.databricks.cluster.profile" : "serverless",
    #"spark.databricks.acl.dfAclsEnabled" : true,
    "spark.sql.adaptive.enabled" : true,
    "spark.databricks.pyspark.enableProcessIsolation" : true
  }
  library {
    pypi {
      package = "pyodbc"
    }
  }
}
