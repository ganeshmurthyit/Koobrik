data "databricks_node_type" "smallest" {
  local_disk = true
  depends_on = [var.workspace]
}
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  depends_on        = [var.workspace]
}
data "databricks_current_user" "me" {
  depends_on = [var.workspace]
}
data "databricks_spark_version" "ml" {
  ml         = true
  depends_on = [var.workspace]
}
resource "databricks_instance_pool" "defaultPool" {
  instance_pool_name                    = join("", [var.prefix, "-", "defaultInstancePool", "-", var.suffix])
  min_idle_instances                    = 0
  max_capacity                          = 10
  node_type_id                          = var.nodeTypeIdPool
  preloaded_spark_versions              = var.sparkVersion
  idle_instance_autotermination_minutes = 10
  depends_on                            = [var.workspace]
}

output "defaultPoolId" {
  value = databricks_instance_pool.defaultPool.id
}

