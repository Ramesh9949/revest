variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "amis" {
  description = "AMIs by region"
  default = {
    us-east-1 = "ami-04b70fa74e45c3917" # ubuntu 14.04 LTS
  }
}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "IGW_name" {}
variable "key_name" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "private_subnet1_cidr" {}
variable "public_subnet1_name" {}
variable "public_subnet2_name" {}
variable "private_subnet1_name" {}
variable "Main_Routing_Table" {}
variable "private_Routing_Table" {}

