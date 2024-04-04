data "databricks_current_user" "me" {
  depends_on = [var.workspace]
}

resource "databricks_sql_endpoint" "this" {
  name             = join("", [var.prefix, "-", "awsSqlEndpoint", "-", var.suffix])
  cluster_size     = "2X-Small"
  max_num_clusters = 1
  auto_stop_mins   = "20"
}
