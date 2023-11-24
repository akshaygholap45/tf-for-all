terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0efcece6bed30fd98"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_server-sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sleep 10
    rm -rf /var/www/html/*.html
    echo "<H1>Hello, Everyone</H1>" > /var/www/html/index.html
  EOF
  
  user_data_replace_on_change = true

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_security_group" "app_server-sg" {
  name = "app_server-example-security-group"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}