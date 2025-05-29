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
# Create launch template for application tier
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  network_interfaces {
    security_groups = [var.app_sg_id]
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install -y java-openjdk11
    
    # Install application server (Tomcat)
    cd /opt
    wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
    tar -xzf apache-tomcat-9.0.78.tar.gz
    mv apache-tomcat-9.0.78 tomcat
    rm apache-tomcat-9.0.78.tar.gz
    
    # Configure Tomcat
    cat > /opt/tomcat/webapps/ROOT/index.jsp << 'INNEREOF'
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Application Tier</title>
    </head>
    <body>
        <h1>Welcome to the Application Tier - <%= java.net.InetAddress.getLocalHost().getHostName() %></h1>
        <p>Three-Tier Architecture Demo - ${var.environment} Environment</p>
        <p>Server time: <%= new java.util.Date() %></p>
    </body>
    </html>
    INNEREOF
    
    # Start Tomcat
    /opt/tomcat/bin/startup.sh
    
    # Configure Tomcat to start on boot
    cat > /etc/systemd/system/tomcat.service << 'INNEREOF'
    [Unit]
    Description=Apache Tomcat Web Application Container
    After=network.target
    
    [Service]
    Type=forking
    Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk"
    Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
    Environment="CATALINA_HOME=/opt/tomcat"
    Environment="CATALINA_BASE=/opt/tomcat"
    
    ExecStart=/opt/tomcat/bin/startup.sh
    ExecStop=/opt/tomcat/bin/shutdown.sh
    
    [Install]
    WantedBy=multi-user.target
    INNEREOF
    
    systemctl daemon-reload
    systemctl start tomcat
    systemctl enable tomcat
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-app-server"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Create internal load balancer for app tier
resource "aws_lb" "app" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_sg_id]
  subnets            = var.private_app_subnet_ids
  enable_deletion_protection = false
  tags = {
    Name = "${var.project_name}-${var.environment}-app-alb"
  }
}
# Create ALB target group
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-${var.environment}-app-tg"
  port     = 8080
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
    Name = "${var.project_name}-${var.environment}-app-tg"
  }
}
# Create ALB listener
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
# Create autoscaling group
resource "aws_autoscaling_group" "app" {
  name                      = "${var.project_name}-${var.environment}-app-asg"
  max_size                  = var.app_instance_count * 2
  min_size                  = var.app_instance_count
  desired_capacity          = var.app_instance_count
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.app.arn]
  vpc_zone_identifier       = var.private_app_subnet_ids
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
