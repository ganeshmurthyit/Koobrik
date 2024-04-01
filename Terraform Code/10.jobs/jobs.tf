data "databricks_spark_version" "ml" {
  ml         = true
  depends_on = [var.workspace]
}

resource "databricks_job" "jobsql" {
  name = join("", [var.prefix, "-", "UATAwsSql", "-", var.suffix])
  new_cluster {
    // cluster_name              = "UAT_Cluster"
    spark_version           = data.databricks_spark_version.ml.id
    instance_pool_id        = var.defaultPoolId
    driver_instance_pool_id = var.defaultPoolId
    autoscale {
      min_workers = 1
      max_workers = 3
    }
    spark_conf = {
      "spark.databricks.delta.preview.enabled" : true,
      "spark.rpc.message.maxSize" : "1024",
      "ReservedCodeCacheSize" : "3072m",
      "spark.scheduler.mode" : "FAIR"
    }
  }
  schedule {
    quartz_cron_expression = "0 * * * * ?"
    timezone_id            = "Asia/Kolkata"
  }
  notebook_task {
    notebook_path = "/Repos/karthik@koantek.com/....."
    base_parameters = {
      "timeoutSeconds" : "43200"
      "projectName" : join("", [var.prefix, "-", "AwsJob", "-", var.suffix])
      "threadPool" : "1"
      "whatIf" : "0"
      "hydrationBehavior" : "Force"
      "repoPath" : "/Workspace/Repos/..."
    }
  }
  library {
    maven {
      coordinates = "com.microsoft.azure:spark-mssql-connector_2.12:1.2.0"
    }
  }
  library {
    pypi {
      package = "great_expectations"
    }
  }
  library {
    pypi {
      package = "pyodbc"
    }
  }
  library {
    pypi {
      package = "databricks-api"
    }
  }
  library {
    pypi {
      package = "loguru"
    }
  }
  library {
    whl = "dbfs:/FileStore/jars/ktk-0.0.1-py3-none-any.whl"
  }
}

