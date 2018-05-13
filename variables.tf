############################################################################
# AWS Configuration                                                        #
############################################################################
variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret access key"
}

variable "region" {
  description = "AWS region"
}

###########################  VPC Config ################################

variable "vpc_name" {
  description = "Name of VPC"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
}

variable "availability_zones" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "database_subnets" {
  type = "list"
}

###########################  ECS Config ################################

variable "ecs_cluster_names" {
  type = "map"

  default = {
    public    = "public-cluster"
    appserver = "appserver-cluster"
    dbserver  = "dbserver-cluster"
  }
}

variable "ecs_key_pair_name" {
  description = "EC2 instance key pair name"
}

variable "ecs_ami" {
  type = "map"
  description = "Map of Amazon ECS-optimized AMIs per region"
}
