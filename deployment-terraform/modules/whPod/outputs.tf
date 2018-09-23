### Outputs

output "lb_ip" {
  value = "${kubernetes_service.nginx_Terraform_Svc.load_balancer_ingress.0.hostname}"
}