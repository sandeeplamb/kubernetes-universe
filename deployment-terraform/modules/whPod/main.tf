############################################################################
######## AWS-Resources-Definition-Only-Below-This ##########################
############################################################################

### Terraform Pod-Definition
resource "kubernetes_pod" "nginx_Terraform_Pod" {
  metadata {
    name = "${var.pod_name}"
    labels {
      App = "${var.pod_app_label}"
    }
  }

  spec {
    container {
      image = "${var.pod_image}"
      name  = "${var.pod_container_name}"
      port {
        container_port = "${var.pod_port}"
         }
    }
  }
}

### Terraform Service-Definition
resource "kubernetes_service" "nginx_Terraform_Svc" {
  metadata {
    name = "${var.pod_name}"
  }
  spec {
    selector {
      App = "${kubernetes_pod.nginx_Terraform_Pod.metadata.0.labels.App}"
    }
    port {
      port = "${var.pod_port}"
      target_port = "${var.pod_port}"
    }

    type = "${var.svc_type}"
  }
}