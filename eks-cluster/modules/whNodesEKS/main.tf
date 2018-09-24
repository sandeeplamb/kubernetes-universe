############################################################################
### EKS-USERDATA
############################################################################

### The configuration below is changing the kubelet.service config file and replacing the IP's
### and regions, pods, DNS, certs value correctly in stystemd and conf file
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash -xe

CA_CERTIFICATE_DIRECTORY=/etc/kubernetes/pki
CA_CERTIFICATE_FILE_PATH=$CA_CERTIFICATE_DIRECTORY/ca.crt
mkdir -p $CA_CERTIFICATE_DIRECTORY
echo "${var.eks_ca_data_out}" | base64 -d >  $CA_CERTIFICATE_FILE_PATH
INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i s,MASTER_ENDPOINT,${var.eks_ep_out},g /var/lib/kubelet/kubeconfig
sed -i s,CLUSTER_NAME,${var.EKS_Cluster_Name},g /var/lib/kubelet/kubeconfig
sed -i s,REGION,${var.region},g /etc/systemd/system/kubelet.service
sed -i s,MAX_PODS,20,g /etc/systemd/system/kubelet.service
sed -i s,MASTER_ENDPOINT,${var.eks_ep_out},g /etc/systemd/system/kubelet.service
sed -i s,INTERNAL_IP,$INTERNAL_IP,g /etc/systemd/system/kubelet.service
DNS_CLUSTER_IP=10.100.0.10
if [[ $INTERNAL_IP == 10.* ]] ; then DNS_CLUSTER_IP=172.20.0.10; fi
sed -i s,DNS_CLUSTER_IP,$DNS_CLUSTER_IP,g /etc/systemd/system/kubelet.service
sed -i s,CERTIFICATE_AUTHORITY_FILE,$CA_CERTIFICATE_FILE_PATH,g /var/lib/kubelet/kubeconfig
sed -i s,CLIENT_CA_FILE,$CA_CERTIFICATE_FILE_PATH,g  /etc/systemd/system/kubelet.service
systemctl daemon-reload
systemctl restart kubelet
USERDATA
}

############################################################################
### EKS-Node-Create-Role-And-Instance-Profile
############################################################################

resource "aws_iam_role" "EKSNodeRole" {
  name = "EKS-Node-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "PoC-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.EKSNodeRole.name}"
}

resource "aws_iam_role_policy_attachment" "PoC-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.EKSNodeRole.name}"
}

resource "aws_iam_role_policy_attachment" "PoC-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.EKSNodeRole.name}"
}

resource "aws_iam_instance_profile" "EKSInstanceProfile" {
  name = "${var.EKS_Cluster_Name}"
  role = "${aws_iam_role.EKSNodeRole.name}"
}

############################################################################
### EKS-Node-Security-Groups
############################################################################

resource "aws_security_group" "EKSPoCNodeSG01" {
  name        = "${var.EKS_Cluster_Name}-node"
  description = "Security Group For All Nodes In Cluster"
  vpc_id      = "${var.vpc_id_output}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${local.workstation-external-cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.EKS_Cluster_Name}-node",
     "kubernetes.io/cluster/${var.EKS_Cluster_Name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow Node to Communicate With Each Others"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.EKSPoCNodeSG01.id}"
  source_security_group_id = "${aws_security_group.EKSPoCNodeSG01.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow Worker Kubelets-Pods To Communicate With Cluster Control Plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.EKSPoCNodeSG01.id}"
  source_security_group_id = "${var.eks_sg_out}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow Pods To Communicate With Cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${var.eks_sg_out}"
  source_security_group_id = "${aws_security_group.EKSPoCNodeSG01.id}"
  to_port                  = 443
  type                     = "ingress"
}

############################################################################
### EKS-Launch-Configuration
############################################################################

#data "aws_ami" "eks-worker" {
#  filter {
#    name   = "name"
#    values = ["eks-worker-*"]
#  }

#  most_recent = true
#  owners      = ["136335740207"] # Amazon
#}


resource "aws_launch_configuration" "eks_node_lc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.EKSInstanceProfile.name}"
  image_id                    = "${lookup(var.ami, var.region)}"
  #image_id                    = "${data.aws_ami.eks-worker.id}"
  #image_id                    = "ami-790b6306"
  key_name                    = "${var.key_name}"
  instance_type               = "t2.large"
  name_prefix                 = "${var.EKS_Cluster_Name}"
  #security_groups             = ["${var.Public_SG_out}"]
  security_groups             = ["${aws_security_group.EKSPoCNodeSG01.id}"]
  user_data_base64            = "${base64encode(local.eks-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}


############################################################################
### EKS-Auto-Scaling-Group
############################################################################

resource "aws_autoscaling_group" "eks_nodes_asg" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.eks_node_lc.id}"
  max_size             = 2
  min_size             = 1
  name                 = "${var.EKS_Cluster_Name}"
  vpc_zone_identifier  = ["${var.Public_SN_01_out_01}","${var.Public_SN_02_out_02}","${var.Public_SN_03_out_03}"]

 tag {
    key                 = "Name"
    value               = "${var.EKS_Cluster_Name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.EKS_Cluster_Name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

############################################################################
### EKS-OutPut
############################################################################
