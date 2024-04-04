resource "databricks_git_credential" "git" {
  git_username          = ""
  git_provider          = "azureDevOpsServices"
  personal_access_token = ""
}

resource "databricks_repo" "databricksRepo" {
  url          = ""
  git_provider = "azureDevOpsServices"
  branch       = "main"
}

