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

  description = "Amazon ECS-optimized AMIs per region"

  default = {
    us-east-2      = "ami-64300001"
    us-east-1      = "ami-aff65ad2"
    us-west-2      = "ami-40ddb938"
    us-west-1      = "ami-69677709"
    eu-west-2      = "ami-2218f945"
    eu-west-3      = "ami-250eb858"
    eu-west-1      = "ami-2d386654"
    eu-central-1   = "ami-9fc39c74"
    ap-northeast-2 = "ami-9d56f9f3"
    ap-northeast-1 = "ami-a99d8ad5"
    ap-southeast-2 = "ami-efda148d"
    ap-southeast-1 = "ami-846144f8"
    ca-central-1   = "ami-897ff9ed"
    ap-south-1     = "ami-72edc81d"
    sa-east-1      = "ami-4a7e2826"
  }
}
