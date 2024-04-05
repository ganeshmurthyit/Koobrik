terraform {
  backend "s3" {
    bucket  = "koobrik-testing"                     // s3 bucket name
    key     = "tfstate/dbkoobrik2.tfstate" //folder path in bucket to store state file
    region  = "us-east-2"                      // bucket region
    encrypt = true
    # dynamodb_table = "ktkterraformnew-lock"

  }
}
