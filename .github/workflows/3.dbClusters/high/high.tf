
resource "databricks_cluster" "high" {
  cluster_name            = join("", [var.prefix, "-", "high", "-", var.suffix])
  spark_version           = var.sparkVersionCluster
  instance_pool_id        = var.defaultPoolId
  driver_instance_pool_id = var.defaultPoolId
  autotermination_minutes = 20
  autoscale {
    min_workers = "1"
    max_workers = "2"
  }
  spark_conf = {
    "spark.databricks.repl.allowedLanguages" : "python,sql,scala",
    #"spark.databricks.cluster.profile": "serverless",
    #"spark.databricks.delta.preview.enabled" : true
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

  custom_tags = {
    "ResourceClass" = "Serverless"
  }
}
