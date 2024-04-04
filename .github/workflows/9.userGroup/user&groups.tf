data "databricks_group" "admins" {
  display_name = "admins"
  depends_on   = [var.workspace]
}

resource "databricks_user" "me1" {
  user_name = "pankaj.wani@koantek.com"
}


resource "databricks_user" "me2" {
  user_name = "sumanth.s.gunasani@koantek.com"
}

resource "databricks_user" "me3" {
  user_name = "jayanth.chinnam@koantek.com"
}



resource "databricks_group_member" "a1" {
  group_id  = data.databricks_group.admins.id
  member_id = databricks_user.me2.id
}


resource "databricks_group" "spectators" {
  display_name = "awsContributor"
}

resource "databricks_group" "Reader" {
  display_name = "awsReader"
}


resource "databricks_group_member" "a2" {
  group_id  = databricks_group.spectators.id
  member_id = databricks_user.me2.id
}

resource "databricks_group_member" "a3" {
  group_id  = databricks_group.spectators.id
  member_id = databricks_user.me1.id
}
