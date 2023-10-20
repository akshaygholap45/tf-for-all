terraform {
  backend "s3" {
    bucket = "tf-for-all"
    key = "services/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "mysql" {
  source = "../../../../modules/services/mysql"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  db_password = var.db_password
  db_username = var.db_username
}