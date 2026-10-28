terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

resource "aws_s3_bucket" "customer_data" {
  bucket = "acme-customer-data"
  acl    = "public-read"
}

resource "aws_s3_bucket" "backups" {
  bucket = "acme-backups"
  acl    = "public-read"
}

resource "aws_s3_bucket" "logs" {
  bucket = "acme-logs"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "static" {
  bucket = "acme-static"
}

resource "aws_db_instance" "payments" {
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_encrypted   = false
  publicly_accessible = true
  username            = "admin"
  password            = "SuperSecret123!"
}

resource "aws_db_instance" "analytics" {
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_encrypted   = false
  publicly_accessible = true
  username            = "admin"
  password            = "Analytics123!"
}

resource "aws_ebs_volume" "data" {
  availability_zone = "ap-south-1a"
  size              = 100
  encrypted         = false
}

resource "aws_efs_file_system" "shared" {
  creation_token = "acme-shared"
  encrypted      = false
}

resource "aws_security_group" "web" {
  name = "web-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name = "db-sg"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "admin" {
  name = "admin-sg"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "app_policy" {
  name = "app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "admin_role" {
  name = "admin-role-policy"
  role = "some-role"
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy" "dev_user" {
  name = "dev-user-policy"
  user = "dev"
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:*"]
      Resource = "*"
    }]
  })
}

resource "aws_lb" "app" {
  name               = "acme-alb"
  internal           = false
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "app" {
  name     = "acme-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-0-2015-04"
  certificate_arn   = "arn:aws:acm:ap-south-1:123456789012:certificate/xxx"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_listener" "http_plain" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
