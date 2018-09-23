# Kubernetes Playgroud - Terraform Deployment

Terraform have provided Kubernetes Provider and we can deploy the Kubernetes resources using terraform now.

**Commands**

```
[slamba ◯  WHM0005395  01.Deployment ] ☘   terraform init
[slamba ◯  WHM0005395  01.Deployment ] ☘   terraform plan
[slamba ◯  WHM0005395  01.Deployment ] ☘   terraform apply
[slamba ◯  WHM0005395  01.Deployment ] ☘   terraform output -module=whPod
[slamba ◯  WHM0005395  01.Deployment ] ☘   terraform output -module=whPod lb_ip
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl get pods nginx-terraform-pod
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl get svc nginx-terraform-pod
```

**Demo**

<p align="center">
  <a href="https://asciinema.org/a/PncOYuZ7m6uCMAhzr8BbXJfNQ?speed=2&amp;autoplay=1">
  <img src="https://asciinema.org/a/PncOYuZ7m6uCMAhzr8BbXJfNQ.png" width="585"></image>
  </a>
</p>