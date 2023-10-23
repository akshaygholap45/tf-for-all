terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "terraform_remote_state" "db" {
  backend = "s3"

  workspace = "stage"

  config = {
    bucket = "tf-for-all"
    key    = "services/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}