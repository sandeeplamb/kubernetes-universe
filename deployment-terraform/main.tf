provider "kubernetes" {

    #host = "https://7D1B5232E5CC198E1631169536BC58E4.yl4.us-east-1.eks.amazonaws.com"

    #client_certificate     = "${file("~/.kube/client-cert.pem")}"
    #client_key             = "${file("~/.kube/client-key.pem")}"
    #cluster_ca_certificate = "${file("~/.kube/ca_pem.pem")}"
}

### 01.Module-Pod-Creation
module "whPod" {
  source            = "./modules/whPod"
}