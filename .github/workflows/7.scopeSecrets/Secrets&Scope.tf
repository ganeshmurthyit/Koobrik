
resource "databricks_secret_scope" "dbSecretScope" {
  name = "demo"
}


resource "databricks_token" "pat" {
  comment = "Created from ${abspath(path.module)}"
  // lifetime_seconds = 3600
}

resource "databricks_secret" "token" {
  string_value = databricks_token.pat.token_value
  scope        = databricks_secret_scope.dbSecretScope.name
  key          = "token"
}



