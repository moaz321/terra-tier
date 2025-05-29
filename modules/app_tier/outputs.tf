output "app_alb_dns_name" {
  description = "DNS name of the application tier load balancer"
  value       = aws_lb.app.dns_name
}
output "app_asg_name" {
  description = "Name of the application tier autoscaling group"
  value       = aws_autoscaling_group.app.name
}
