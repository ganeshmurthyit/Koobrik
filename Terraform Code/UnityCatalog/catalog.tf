resource "databricks_catalog" "sandbox" {
  provider     = databricks.workspace
  metastore_id = databricks_metastore.this.id
  name         = var.name_catalog
  comment      = "this catalog is managed by terraform"
  properties = {
    purpose = "testing"
  }
  depends_on = [databricks_metastore_assignment.default_metastore]
}

resource "databricks_grants" "sandbox" {
  provider = databricks.workspace
  catalog  = databricks_catalog.sandbox.name
  grant {
    principal  = "Data Scientists"
    privileges = ["USAGE", "CREATE"]
  }
  grant {
    principal  = "Data Engineers"
    privileges = ["USAGE"]
  }
}

# resource "databricks_schema" "things" {
#   provider     = databricks.workspace
#   catalog_name = databricks_catalog.sandbox.id
#   name         = var.name_schema
#   comment      = "this database is managed by terraform"
#   properties = {
#     kind = "various"
#   }
# }

# resource "databricks_grants" "things2" {
#   provider = databricks.workspace
#   schema   = databricks_schema.things.id
#   grant {
#     principal  = "Devops"
#     privileges = ["USE_SCHEMA"]
#   }
# }


# #Catalog grants

# resource "databricks_grants" "sandbox1" {
#   provider = databricks.workspace
#   catalog = databricks_catalog.sandbox.name
#   grant {
#     principal  = "Devops"
#     privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
#   }
# }



#table creation


# resource "databricks_table" "thing" {
#   provider           = databricks.workspace
#   name               = "ucgrants_table"
#   catalog_name       = databricks_catalog.sandbox.id
#   schema_name        = databricks_schema.things.name
#   table_type         = "MANAGED"
#   data_source_format = "DELTA"
#   storage_location   = ""

#   column {
#     name      = "id"
#     position  = 0
#     type_name = "INT"
#     type_text = "int"
#     type_json = "{\"name\":\"id\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}}"
#   }
#   column {
#     name      = "name"
#     position  = 1
#     type_name = "STRING"
#     type_text = "varchar(64)"
#     type_json = "{\"name\":\"name\",\"type\":\"varchar(64)\",\"nullable\":true,\"metadata\":{}}"
#   }
#   comment = "this table is managed by terraform"
# }

# resource "databricks_grants" "customers" {
#   provider           = databricks.workspace
#   table = "sigma_catalog.sigma_db.ucgrants_table"
  
#   grant {
#     principal  = "Devops"
#     privileges = ["MODIFY", "SELECT"]
#   }
# }

# #Table grants

# data "databricks_tables" "things" {
#   provider           = databricks.workspace
#   catalog_name = databricks_catalog.sandbox.name
#   schema_name  = databricks_schema.things.name
# }

# resource "databricks_grants" "things" {
#   provider           = databricks.workspace
#   for_each = data.databricks_tables.things.ids

#   table = each.value

#   grant {
#     principal  = "Devops"
#     privileges = ["SELECT", "MODIFY"]
#   }
# }