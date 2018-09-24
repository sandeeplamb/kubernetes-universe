## Variable - Access-Key
#variable "access_key" {
#  description = "AWS-Sandbox Account Access Key"
#}

## Variable Secret-Key
#variable "secret_key" {
#  description = "AWS-Sandbox Account Secret Key"
#}

## Variable Region
#variable "region" {
#  description = "AWS-Region"
#  default     = "us-east-1"
#}

variable "cidr" {
  description = "The CIDR of the VPC."
  default     = "10.0.0.0/16"
}
variable "public_subnet" {
  description = "The public subnet to create."
  default     = "10.0.1.0/24"
}
variable "public_subnet_2" {
  description = "The public subnet to create."
  default     = "10.0.3.0/24"
}
variable "public_subnet_3" {
  description = "The public subnet to create."
  default     = "10.0.5.0/24"
}
variable "private_subnet" {
  description = "The private subnet to create."
  default     = "10.0.2.0/24"
}
variable "private_subnet_2" {
  description = "The private subnet to create."
  default     = "10.0.4.0/24"
}
variable "private_subnet_3" {
  description = "The private subnet to create."
  default     = "10.0.6.0/24"
}

variable "EKS_Cluster_Name" {
  description = "EKS Cluster Name"
  default = "PoC-EKS-Cluster-01"
  type    = "string"
}



## Region AZ Public Subnet
variable "region_az_sn" {
  description   = "AWS-Region-AZ-Public-Subnet"
  type		= "map"
  default       = { 
    "10.0.1.0/24" = "us-east-1b"
    "10.0.3.0/24" = "us-east-1c"
    "10.0.5.0/24" = "us-east-1d"
    "10.0.2.0/24" = "us-east-1d"
    "10.0.4.0/24" = "us-east-1e"
    "10.0.6.0/24" = "us-east-1f"
  }
}

## Variable 
variable "subnets" {
  description	= "Regions-AZ-subnets"
  type		= "map"

  default = {
    us-east-2a = "subnet-3d315455"
    us-east-2b = "subnet-abf82ad1"
    us-east-2c = "subnet-56aeac1b"
  }
}
