region = "eu-west-1"

vpc_name = "test_vpc"

vpc_cidr = "192.168.0.0/16"

availability_zones = ["eu-west-1a", "eu-west-1b"]

private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]

public_subnets = ["192.168.101.0/24", "192.168.102.0/24"]

database_subnets = ["192.168.201.0/24", "192.168.202.0/24"]

ecs_key_pair_name="KP124"

ecs_ami = {
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
