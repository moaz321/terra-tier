# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Create launch template for web tier
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-${var.environment}-web-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.web_sg_id]
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Welcome to the Web Tier - $(hostname -f)</h1>" > /var/www/html/index.html
    echo "<p>Three-Tier Architecture Demo - ${var.environment} Environment</p>" >> /var/www/html/index.html
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-web-server"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Create Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
  tags = {
    Name = "${var.project_name}-${var.environment}-web-alb"
  }
}
# Create ALB target group
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-web-tg"
  }
}
# Create ALB listener
resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
# Create autoscaling group
resource "aws_autoscaling_group" "web" {
  name                      = "${var.project_name}-${var.environment}-web-asg"
  max_size                  = var.web_instance_count * 2
  min_size                  = var.web_instance_count
  desired_capacity          = var.web_instance_count
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.web.arn]
  vpc_zone_identifier       = var.public_subnet_ids
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-web-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
