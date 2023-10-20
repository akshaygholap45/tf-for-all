terraform {
  backend "s3" {
    bucket = "tf-for-all"
    key = "services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "tf-for-all"
    key = "stage/services/mysql/terraform.tfstate"
    region = var.aws_region
  }
}