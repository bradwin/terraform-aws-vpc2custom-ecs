resource "aws_ecs_cluster" "public-ecs-cluster" {
  name = "${lookup(var.ecs_cluster_names, "public")}"
}

resource "aws_ecs_cluster" "appserver-ecs-cluster" {
  name = "${lookup(var.ecs_cluster_names, "appserver")}"
}

resource "aws_ecs_cluster" "dbserver-ecs-cluster" {
  name = "${lookup(var.ecs_cluster_names, "dbserver")}"
}
