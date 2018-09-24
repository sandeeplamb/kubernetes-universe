############################################################################
### EKS-IAM-Role
############################################################################
resource "aws_iam_role" "EKSPoCRole" {
  name = "${var.EKS_Cluster_Name}-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.EKSPoCRole.name}"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.EKSPoCRole.name}"
}


############################################################################
### EKS-Security-Groups
############################################################################
resource "aws_security_group" "EKSPoCSG01" {
  name        = "${var.EKS_Cluster_Name}-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id_output}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
     Name = "${var.EKS_Cluster_Name}"
  }
}

resource "aws_security_group_rule" "eks-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allowing Workstation to Communicate to API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.EKSPoCSG01.id}"
  to_port           = 443
  type              = "ingress"
}

############################################################################
### EKS-Definition
############################################################################
resource "aws_eks_cluster" "PoCEKSCluster01" {
  name            = "${var.EKS_Cluster_Name}"
  role_arn        = "${aws_iam_role.EKSPoCRole.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.EKSPoCSG01.id}"]
    subnet_ids         = ["${var.Public_SN_01_out_01}","${var.Public_SN_02_out_02}","${var.Public_SN_03_out_03}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
  ]
}


############################################################################
### EKS-OutPut-Kube-Config-Data
############################################################################
locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.PoCEKSCluster01.endpoint}
    certificate-authority-data: ${aws_eks_cluster.PoCEKSCluster01.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "${var.EKS_Cluster_Name}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}