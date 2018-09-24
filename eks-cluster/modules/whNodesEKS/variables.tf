############################################################################
## Output-Variables
############################################################################
############################################################################
## Output-Variables
############################################################################
variable "Public_SN_01_out_01" {
  #type = "list"
  description = "Module-whVPC-Public-SN-01-ID"
  default = ""
}

variable "Public_SN_02_out_02" {
  #type = "list"
  description = "Module-whVPC-Public-SN-02-ID"
  default = ""
}

variable "Public_SN_03_out_03" {
  #type = "list"
  description = "Module-whVPC-Public-SN-03-ID"
  default = ""
}

variable "Public_SG_out" {
  type = "list"
  description = "Module-whVPC-Public-SG-ID"
  default = []
}


variable "eks_ep_out" { 
  description = "Module-whEKS-EndPoint"
  default = ""
}

variable "eks_ca_data_out" {
  description = "Module-whEKS-CA-Data"
  default = ""
}

variable "vpc_id_output" {
  description = "Module-whVPC-ID"
  default = ""
}

variable "eks_sg_out" {
  description = "Module-EKS-Security-Group-ID"
  default = ""
}
############################################################################
### EKS-Variables
############################################################################
variable "EKS_Cluster_Name" {
  description = "EKS Cluster Name"
  default = "PoC-EKS-Cluster-01"
  type    = "string"
}


#variable "EKS_Role_ARN" {
#  description = "EKS Role ARN"
#  default = "arn:aws:iam::123123123123:role/eks-role"
#  type    = "string"
#}

############################################################################
### Global-Variables
############################################################################
## Variable - Access-Key
#variable "access_key" {
#  description = "AWS-Sandbox Account Access Key"
#}

## Variable Secret-Key
#variable "secret_key" {
#  description = "AWS-Sandbox Account Secret Key"
#}

## Variable Region
variable "region" {
  description = "AWS-Region"
  default     = "us-east-1"
}

## Variable AMI
variable "ami" {
  description = "AWS-AMI's per Region"
  type        = "map"

  default = {
    us-east-1 = "ami-790b6306"
    us-west-2 = "ami-c9552fb1"
  }
}

variable "key_name" {
  description = "EC2-Key-Name"
  default     = "aws-sandbox"
}
