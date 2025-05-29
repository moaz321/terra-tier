terraform {
  backend "s3" {
    bucket         = "BUCKET_NAME_PLACEHOLDER"
    key            = "three-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "DYNAMODB_TABLE_PLACEHOLDER"
    encrypt        = true
  }
}

