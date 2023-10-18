# Launch Configuration
resource "aws_launch_configuration" "example" {
  image_id = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install nginx -y
                EOF
  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for Launch Config
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = aws_vpc.m4l_vpc.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0

    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = [ aws_subnet.SNPUBA.id, aws_subnet.SNPUBB.id, aws_subnet.SNPUBC.id ]
  
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  
  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform-example"
    propagate_at_launch = true
  }
}

# Load Balancer
resource "aws_lb" "example" {
  name = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = [ aws_subnet.SNPUBA.id, aws_subnet.SNPUBB.id, aws_subnet.SNPUBC.id ]
  security_groups = [aws_security_group.alb.id]
}

# LB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

# Listener Rule
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# Security Group for LB
resource "aws_security_group" "alb" {
  name = "terraform-example-alb"
  vpc_id = aws_vpc.m4l_vpc.id

  ingress {
    from_port = 80
    to_port = 80
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

# Target Group
resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = aws_vpc.m4l_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# DNS Name of LB
output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}