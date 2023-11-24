locals {
    http_port = 80
    any_port = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    all_ips = ["0.0.0.0/0"]
}

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

variable "aws_instance_type" {
    type = string
    default = "t2.micro"
}

variable "aws_ami" {
    type = string
    default = "ami-01bc990364452ab3e"
}

variable "min_size" {
    type = number
    description = "The minimum number of EC2 Instances in ASG"
}

variable "max_size" {
    type = number
    description = "The maximum number of EC2 Instances in ASG"
}
variable "server_port" {
    type = number
    default = 80
}

variable "cluster_name" {
    description = "The name of the cluster"
    type = string
}
