# Terraforming 3-Tier VPC on AWS

This demonstrates how to create a multi-AZ 3-tier VPC on AWS. The architecture is based on AWS VPC Scenario 2 but with 3 subnets: 

   - Public subnet for http servers 
   - Private subnet for application servers
   - Private subnet for database servers

As per the AWS blueprint, there is a an internet gateway that routes external traffic from the public subnet to the internet. There is a single NAT gateway associated with the 2 private subnets. 

VPC is provisioned using Terraform. 

ECS clusters are created on each tier and sample off-the-shelf Docker containers are deployed to demonstrate how containers will be deployed to the tiers. if required, the number of EC2 instances per cluster can be tweaked by editing the service definitions in `ecs-task-definition.tf`.

## Installation

To run this, make sure you have setup the following pre-requisites:

  - Terraform v0.11.7 (or latest)
  - AWS keys set as environment variables using TF_VAR_aws_access_key and TF_VAR_aws_secret_key. Optionally, you may add these in terraform.tfvars

Clone the repository from GitHub:

```sh
$ git clone https://github.com/bradwin/tf-aws-vpc2-ecs.git
$ cd tf-aws-vpc2-ecs
```

Use Terraform to run and create the infrastucture: 

```sh
$ terraform init
$ terraform apply
```

To teardown, use Terraform destroy: 

```sh
$ terraform destroy -force
```

## Configuration 

The source is designed to deploy parallel structures on 2 availability zones. There are a few settings that can be configured via `terraform.tfvars`.

| Variable           | Default                                  | Description                                        |
| :------------------| :--------------------------------------- | :------------------------------------------------- |
| region             | "eu-west-1"                              | AWS region to create the VPC on                    |
| vpc_name           | "test_vpc"                               | Name of the VPC                                    | 
| vpc_cidr           | "192.168.0.0/16"                         | CIDR block for the VPC                             | 
| availability_zones | ["eu-west-1a", "eu-west-1b"]             | AZs to use, these should both be within the region |
| public_subnet      | ["192.168.101.0/24", "192.168.102.0/24"] | CIDR blocks for the public subnets                 |
| private_subnets    | ["192.168.1.0/24", "192.168.2.0/24"]     | CIDR blocks for the app server subnets             | 
| database_subnets   | ["192.168.201.0/24", "192.168.202.0/24"] | CIDR blocks for the database subnets               |
| ecs_key_pair_name  | n/a                                      | change this to your key pair                       |

> By default, a limited set of rules are defined via ingress/egress in the load-balancer and instance security  groups.  These can be configured at `security-groups.tf` to match your application requirements.



## Files and Modules

The source is organized into separate files and modules for easier maintenance.

| File                           | Contents                                   |
| :----------------------------- | :----------------------------------------- |
| `main.tf`                      | AWS provider definition                    |
| `variables.tf`                 | Variables                                  |
| `vpc.tf`                       | VPC and subnets                            |
| `security-groups.tf`           | All security groups for ALBs and instances |
| `application-load-balancer.tf` | Load balancers                             |
| `launch-configuration.tf`      | Launch configurations                      |
| `autoscaling-group.tf`         | Auto scaling groups                        |
| `ecs-cluster.tf`               | ECS clusters                               | 
| `ecs-instance-role.tf`         | ECS instance role definition               |
| `ecs-service-role.tf`          | ECS service role definition                |
| `ecs-task-definition.tf`       | All ECS task and service definitions       | 
