## Variable - Access-Key
variable "access_key" {
  description = "AWS-Sandbox Account Access Key"
}

## Variable Secret-Key
variable "secret_key" {
  description = "AWS-Sandbox Account Secret Key"
}

## Variable Region
variable "region" {
  description = "AWS-Region"
  default     = "us-east-1"
}

## Variable AMI
#variable "ami" {
#  description = "AWS-AMI's per Region"
#  type        = "map"
#
#  default = {
#    us-east-1 = "ami-14c5486b"
#    us-west-2 = "ami-e251209a"
#  }
#}

### EKS-Variables
#variable "EKS_Cluster_Name" {
#  description = "EKS Cluster Name"
#  default = "Poc-EKS-Cluster-01"
#  type    = "string"
#}


#variable "EKS_Role_ARN" {
#  description = "EKS Role ARN"
#  default = "arn:aws:iam::12345678996:role/eks-role"
#  type    = "string"
#}
