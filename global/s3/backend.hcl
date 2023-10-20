# backend.hcl
bucket         = "tf-for-all"
region         = "us-east-1"
dynamodb_table = "terraform-state-locking"
encrypt        = true
