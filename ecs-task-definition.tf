##########################################################################
# Web Servers
##########################################################################
data "aws_ecs_task_definition" "nginx" {
  task_definition = "${aws_ecs_task_definition.nginx.family}"
}

resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"

  container_definitions = <<DEFINITION
  [
    {
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 256,
        "cpu": 256,
        "essential": true,
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
          }
        ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "web-server-service" {
  name            = "web-server-service"
  iam_role        = "${aws_iam_role.ecs-service-role.name}"
  cluster         = "${aws_ecs_cluster.public-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.nginx.family}:${max("${aws_ecs_task_definition.nginx.revision}", "${data.aws_ecs_task_definition.nginx.revision}")}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_alb_target_group.public-ecs-target-group.arn}"
    container_port   = 80
    container_name   = "nginx"
  }
}

##########################################################################
# App Servers
##########################################################################
data "aws_ecs_task_definition" "tomcat" {
  task_definition = "${aws_ecs_task_definition.tomcat.family}"
}

resource "aws_ecs_task_definition" "tomcat" {
  family = "tomcat"

  container_definitions = <<DEFINITION
  [
    {
        "name": "tomcat-webserver",
        "image": "tomcat",
        "memory": 256,
        "cpu": 256,
        "essential": true,
        "portMappings": [
          {
            "containerPort": 8080,
            "hostPort": 8080,
            "protocol": "tcp"
          }
        ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "tomcat-server-service" {
  name            = "tomcat-server-service"
  iam_role        = "${aws_iam_role.ecs-service-role.name}"
  cluster         = "${aws_ecs_cluster.appserver-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.tomcat.family}:${max("${aws_ecs_task_definition.tomcat.revision}", "${data.aws_ecs_task_definition.tomcat.revision}")}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_alb_target_group.appservers-ecs-target-group.arn}"
    container_port   = 8080
    container_name   = "tomcat-webserver"
  }
}

##########################################################################
# DB Servers
##########################################################################
data "aws_ecs_task_definition" "mysql" {
  task_definition = "${aws_ecs_task_definition.mysql.family}"
}

resource "aws_ecs_task_definition" "mysql" {
  family = "mysql"

  container_definitions = <<DEFINITION
  [
    {
        "name": "mysql",
        "image": "mysql",
        "memory": 256,
        "cpu": 256,
        "essential": true,
        "portMappings": [
          {
            "containerPort": 3306,
            "hostPort": 3306,
            "protocol": "tcp"
          }
        ],
        "environment": [
          {
            "name": "MYSQL_ROOT_PASSWORD",
            "value": "password"
          }
        ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "mysql-server-service" {
  name            = "mysql-server-service"
  iam_role        = "${aws_iam_role.ecs-service-role.name}"
  cluster         = "${aws_ecs_cluster.dbserver-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.mysql.family}:${max("${aws_ecs_task_definition.mysql.revision}", "${data.aws_ecs_task_definition.mysql.revision}")}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_alb_target_group.dbservers-ecs-target-group.arn}"
    container_port   = 3306
    container_name   = "mysql"
  }
}
