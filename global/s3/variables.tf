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
    default = "us-east-1"
}