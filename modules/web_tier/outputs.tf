output "web_alb_dns_name" {
  description = "DNS name of the web tier load balancer"
  value       = aws_lb.web.dns_name
}
output "web_asg_name" {
  description = "Name of the web tier autoscaling group"
  value       = aws_autoscaling_group.web.name
}
