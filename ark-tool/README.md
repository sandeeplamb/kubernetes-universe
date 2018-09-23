# Kubernetes Playgroud - Heptio-Ark DR solution for Kubernetes

Heptio ark gives you tools to back up and restore your Kubernetes cluster resources and persistent volume.

## Installation

Ark works in client-server approach.

Install the [Ark-Client](https://github.com/heptio/ark/releases).

Install the server side custom resource definitions as mentioned below or [in this repo](https://github.com/heptio/ark/tree/master/examples).

## Pre-requisites

For storing data in AWS S3 bucket.

1. Create S3 bucket in specific region
2. Create S3 user for bucket that user should have S3 bucket full permission.
3. Create Access key & secret key for that user.
4. Change value of **Access_key** and **Secret_key** in file `00.secret.yaml` in aws.
5. Change bucket name & aws region in file `00-ark-config.yaml`.
6. Change AWS account number & username as your aws account no. and  username in file `02.deployment-kube2iam.yaml`.

**Commands**

```
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl apply -f crd/01.ark_pre_requisites.yaml
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl apply -f aws/.
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl apply -f kubernetes-resources/nginx_deployment.yaml
[slamba ◯  WHM0005395  01.Deployment ] ☘   ark backup create nginx-backup --selector app=nginx
[slamba ◯  WHM0005395  01.Deployment ] ☘   kubectl delete -f kubernetes-resources/nginx_deployment.yaml
[slamba ◯  WHM0005395  01.Deployment ] ☘   ark restore create nginx-backup --from-backup nginx-backup

```

**Demo**

<p align="center">
  <a href="https://asciinema.org/a/briK8gw7BCJNc0mpz8JXl4L5Z?speed=2&amp;autoplay=1">
  <img src="https://asciinema.org/a/briK8gw7BCJNc0mpz8JXl4L5Z.png" width="585"></image>
  </a>
</p>
