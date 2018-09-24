################################################################################
### Public-Subnet-Outputs
################################################################################
output "vpc01_public_subnet_01_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN01.id}"
}

output "vpc01_public_subnet_01_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN01.cidr_block}"
}

output "vpc01_public_subnet_02_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN02.id}"
}

output "vpc01_public_subnet_02_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN02.cidr_block}"
}

output "vpc01_public_subnet_03_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN03.id}"
}

output "vpc01_public_subnet_03_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PubSN03.cidr_block}"
}


################################################################################
### Private-Subnet-Outputs
################################################################################
output "vpc01_private_subnet_01_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN01.id}"
}

output "vpc01_private_subnet_01_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN01.cidr_block}"
}

output "vpc01_private_subnet_02_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN02.id}"
}

output "vpc01_private_subnet_02_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN02.cidr_block}"
}

output "vpc01_private_subnet_03_id" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN03.id}"
}

output "vpc01_private_subnet_03_cidr" {
  value = "${aws_subnet.vpcAWSPoCEKS01PriSN03.cidr_block}"
}

################################################################################
### VPC - Outputs
################################################################################
output "vpc_id" {
  value = "${aws_vpc.vpcAWSPoCEKS01.id}"
}

output "cidr_value" {
  value = "${aws_vpc.vpcAWSPoCEKS01.cidr_block}"
}

output "vpc_route_table_01" {
  value = "${aws_route_table.vpcAWSPoCEKS01RT01.id}"
}

################################################################################
### VPC - Security - Groups
################################################################################

output "vpc_public_sg" {
  value = "${aws_security_group.vpcAWSPoCEKS01PubSNISG.id}"
}

output "vpc_private_sg" {
  value = "${aws_security_group.vpcAWSPoCEKS01PriSNISG.id}"
}