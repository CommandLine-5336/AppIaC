output "jekins_public_ip" {
  description = "Public IP address of the Jenkins server"
  value       = aws_instance.jenkins.public_ip
}

output "lb_public_ip" {
  description = "Public IP address of the Load Balancer"
  value       = aws_instance.lb.public_ip
}
