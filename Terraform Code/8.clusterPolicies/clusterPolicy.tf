variable "policy_overrides" {
  description = "Cluster policy overrides"
  default = {
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 20
    }
  }
}

locals {
  job_policy = {
    "autoscale.min_workers" : {
      "type" : "fixed",
      "value" : 1,
      "hidden" : true
    },
    "autoscale.max_workers" : {
      "type" : "range",
      "maxValue" : 4,
      "defaultValue" : 2
    },
    "node_type_id" : {
      "type" : "fixed",
      "value" : var.nodeTypeIdPool,
      "hidden" : true
    }
  }

  single_policy = {
    "spark_version" : {
      "type" : "regex",
      "pattern" : "1[0-1]\\.[0-9].*",
      "defaultValue" : "11.2.x-scala2.12"
    },
    "data_security_mode" : {
      "type" : "fixed",
      "value" : "SINGLE_USER",
      "hidden" : true
    },
    "single_user_name" : {
      "type" : "regex",
      "pattern" : ".*",
      "hidden" : true
    },
    "spark_conf.spark.databricks.dataLineage.enabled" : {
      "type" : "fixed",
      "value" : "true"
    }
  }
}

resource "databricks_cluster_policy" "jobPolicy" {
  name       = join("", [var.prefix, "-", "awsJobPolicy", "-", var.suffix])
  definition = jsonencode(local.job_policy)
}

resource "databricks_cluster_policy" "allPurposePolicy" {
  name       = join("", [var.prefix, "-", "allPurposePolicy ", "-", var.suffix])
  definition = jsonencode(var.policy_overrides)
}

resource "databricks_cluster_policy" "singlePolicy" {
  name       = join("", [var.prefix, "-", "singlePolicy ", "-", var.suffix])
  definition = jsonencode(merge(local.single_policy, var.policy_overrides))
}

resource "databricks_permissions" "useJobPolicyInstanceProfile" {
  cluster_policy_id = databricks_cluster_policy.jobPolicy.id
  access_control {
    group_name       = "awsContributor"
    permission_level = "CAN_USE"
  }
}

resource "databricks_permissions" "useSinglePolicyInstanceProfile" {
  cluster_policy_id = databricks_cluster_policy.singlePolicy.id
  access_control {
    group_name       = "awsContributor"
    permission_level = "CAN_USE"
  }
}

resource "databricks_permissions" "useAllPurposePolicyInstanceProfile" {
  cluster_policy_id = databricks_cluster_policy.allPurposePolicy.id
  access_control {
    group_name       = "awsContributor"
    permission_level = "CAN_USE"
  }
}

output "jobClusterPolicyId" {
  value = databricks_cluster_policy.jobPolicy.id
}

output "allClusterPolicyId" {
  value = databricks_cluster_policy.allPurposePolicy.id
}

output "singlePolicyId" {
  value = databricks_cluster_policy.singlePolicy.id
}
