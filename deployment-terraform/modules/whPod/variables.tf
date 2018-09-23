### Pod Variables
variable "pod_name" {
  description = "Pod Name"
  default = "nginx-terraform-pod"
}

variable "pod_app_label" {
  description = "Pod Label"
  default = "nginx-terraform-pod"
}

variable "pod_image" {
  description = "Pod Image"
  default = "nginx:1.7.8"
}

variable "pod_container_name" {
  description = "Pod Container Name"
  default = "nginx-terraform-pod"
}

variable "pod_port" {
  description = "Pod Port"
  default = "80"
}

### Service Variables

variable "svc_type" {
  description = "Service Type"
  default = "LoadBalancer"
}
