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

# variable "aws_instance_type" {
#     type = string
#     default = "t2.micro"
# }

# variable "aws_ami" {
#     type = string
#     default = "ami-0261755bbcb8c4a84"
# }

# variable "server_port" {
#     type = number
#     default = 80
# }