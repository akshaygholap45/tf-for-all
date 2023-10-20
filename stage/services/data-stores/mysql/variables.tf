variable "aws_access_key" {
    description = "AWS Access Key"
    type = string
    sensitive = true
}

variable "aws_secret_key" {
    description = "AWS Secret key"
    type = string
    sensitive = true
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "db_username" {
  description = "The username for the database"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "The password for database"
  type = string
  sensitive = true
}