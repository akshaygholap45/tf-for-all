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
