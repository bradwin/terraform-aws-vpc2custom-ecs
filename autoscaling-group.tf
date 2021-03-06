resource "aws_autoscaling_group" "public-autoscaling-group" {
  name                 = "public-autoscaling-group"
  max_size             = "3"
  min_size             = "1"
  desired_capacity     = "2"
  vpc_zone_identifier  = ["${aws_subnet.public-subnet.0.id}", "${aws_subnet.public-subnet.1.id}"]
  launch_configuration = "${aws_launch_configuration.webserver-ecs-launch-configuration.name}"
  health_check_type    = "ELB"
}

resource "aws_autoscaling_group" "appserver-autoscaling-group" {
  name                 = "appserver-autoscaling-group"
  max_size             = "3"
  min_size             = "1"
  desired_capacity     = "2"
  vpc_zone_identifier  = ["${aws_subnet.private-subnet.0.id}", "${aws_subnet.private-subnet.1.id}"]
  launch_configuration = "${aws_launch_configuration.appserver-ecs-launch-configuration.name}"
  health_check_type    = "ELB"
}

resource "aws_autoscaling_group" "dbserver-autoscaling-group" {
  name                 = "dbserver-autoscaling-group"
  max_size             = "3"
  min_size             = "1"
  desired_capacity     = "2"
  vpc_zone_identifier  = ["${aws_subnet.database-subnet.0.id}", "${aws_subnet.database-subnet.1.id}"]
  launch_configuration = "${aws_launch_configuration.dbserver-ecs-launch-configuration.name}"
  health_check_type    = "ELB"
}
