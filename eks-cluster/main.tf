############################################################################
######## AWS-Provider-and-Module-Definition-Only-Below-This ################
############################################################################

### AWS-Provider
provider "aws" {
  access_key        = "${var.access_key}"
  secret_key        = "${var.secret_key}"
  region            = "${var.region}"
}

### 01.Module-VPC-Creation
module "whVPC" {
  source            = "./modules/whVPC"
#  access_key        = "${var.access_key}"
#  secret_key        = "${var.secret_key}"
#  region            = "${var.region}"
}

### 02.Module-EKS-Cluster-Master-Creation
module "whEKS" {
  source              = "./modules/whEKS"
  Public_SN_01_out_01 = "${module.whVPC.vpc01_public_subnet_01_id}"
  Public_SN_02_out_02 = "${module.whVPC.vpc01_public_subnet_02_id}"
  Public_SN_03_out_03 = "${module.whVPC.vpc01_public_subnet_03_id}"
  Public_SG_out       = ["${module.whVPC.vpc_public_sg}"]
  vpc_id_output       = "${module.whVPC.vpc_id}"
#  access_key          = "${var.access_key}"
#  secret_key          = "${var.secret_key}"
#  region              = "${var.region}"
}

### 03.Module-EKS-Cluster-Nodes-Creation
module "whNodesEKS" {
  source              = "./modules/whNodesEKS"
  Public_SN_01_out_01 = "${module.whVPC.vpc01_public_subnet_01_id}"
  Public_SN_02_out_02 = "${module.whVPC.vpc01_public_subnet_02_id}"
  Public_SN_03_out_03 = "${module.whVPC.vpc01_public_subnet_03_id}"
  Public_SG_out       = ["${module.whVPC.vpc_public_sg}"]
  eks_ep_out          = "${module.whEKS.eks_cluster_endpoint}"
  eks_ca_data_out     = "${module.whEKS.eks_cluster_ca_data}"
  vpc_id_output       = "${module.whVPC.vpc_id}"
  eks_sg_out          = "${module.whEKS.eks_cluster_sg_01}"
#  access_key          = "${var.access_key}"
#  secret_key          = "${var.secret_key}"
#  region              = "${var.region}"
}


############################################################################
####################### End ################################################

## Out-Variables-From-Module
#vpc_id_out              = ["${module.whVPC.vpc01_id}"]
#vpc_route_table_01_out  = ["${module.whVPC.vpc_route_table_01}"]
#vpc01_cidr_value_out    = ["${module.whVPC.vpc01_cidr_value}"]


############################################################################
######## AWS-Resources-Definition-Only-Below-This ##########################
############################################################################


### VPC Peering
#resource "aws_vpc_peering_connection" "PoCPeeringEKSVPC" {
#  peer_owner_id           = "${var.vpc_peer_owner_id}"
#  peer_vpc_id             = "${aws_default_vpc.default.id}"
  #peer_vpc_id             = "${var.default_vpc_id}"
  #vpc_id                  = "${var.vpc_id_out}"
#  vpc_id                  = "${module.whVPC.vpc01_id}"
#  auto_accept             = true

#  tags {
#    Name                  = "PoCPeeringEKSVPC"
#    Created_By            = "Sandeep"
#    Created_From          = "Terrafrom"
#  }
#}

#resource "aws_route" "primary2secondary" {
#  route_table_id            = "${aws_default_vpc.default.default_route_table_id}"
  #route_table_id            = "${var.default_vpc_rt_id}"
  #destination_cidr_block    = "${var.vpc01_cidr_value_out}"
#  destination_cidr_block    = "${module.whVPC.vpc01_cidr_value}"
#  vpc_peering_connection_id = "${aws_vpc_peering_connection.PoCPeeringEKSVPC.id}"
#}

/**
 * Route rule.
 *
 * Creates a new route rule on the "secondary" VPC main route table. All
 * requests to the "secondary" VPC's IP range will be directed to the VPC
 * peering connection.
 */
#resource "aws_route" "secondary2primary" {
#  #route_table_id            = "${var.vpc_route_table_01_out}"
#  route_table_id            = "${module.whVPC.vpc_route_table_01}"
#  destination_cidr_block    = "${aws_default_vpc.default.cidr_block}"
  #destination_cidr_block    = "172.31.0.0/16"
#  vpc_peering_connection_id = "${aws_vpc_peering_connection.PoCPeeringEKSVPC.id}"
#}


############################################################################
####################### End ################################################
