terraform {
  backend "s3" {
    bucket  = "ktk-lndnew"                     // s3 bucket name
    key     = "tfstate/ucgrants.tfstate" //folder path in bucket to store state file
    region  = "us-east-2"                      // bucket region
    encrypt = true
    # dynamodb_table = "ktkterraformnew-lock"

  }
}
