variable "aws_access_key" {
    description = "AWS Access Key"
    type = string
}

variable "aws_secret_key" {
    description = "AWS Secret key"
    type = string
}

variable "server_port" {
    description = "webserver port"
    type = number
    default = 80
}