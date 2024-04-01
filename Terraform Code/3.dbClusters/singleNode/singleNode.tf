resource "databricks_cluster" "singleNode" {
  cluster_name            = join("", [var.prefix, "-", "NewSingle", "-", var.suffix])
  spark_version           = var.sparkVersionCluster
  node_type_id            = var.nodeTypeIdPool
  autotermination_minutes = 20

  spark_conf = {
    "spark.databricks.pyspark.enablePy4JSecurity" : false,
    "spark.databricks.cluster.profile" : "singleNode",
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
  aws_attributes {
    ebs_volume_count = 1
    ebs_volume_size  = 100
  }
  library {
    pypi {
      package = "pyodbc"
    }
  }
}
