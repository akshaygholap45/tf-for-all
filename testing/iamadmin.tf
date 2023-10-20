resource "aws_iam_role" "WebserverRole" {
  name = "test_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
    Path = "/",
    ManagedPolicyArnsc = [
      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
      "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
      "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "InstanceProfile" {
  name = "WebserverInstanceProfile"
  path = "/"
  role = aws_iam_role.WebserverRole.arn
  
}