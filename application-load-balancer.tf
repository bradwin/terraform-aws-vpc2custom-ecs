##############################################################################
# PUBLIC Zone Load Balancing
##############################################################################
resource "aws_alb" "public-load-balancer" {
  name            = "public-load-balancer"
  security_groups = ["${aws_security_group.public-alb-sg.id}"]

  subnets = [
    "${aws_subnet.public-subnet.0.id}",
    "${aws_subnet.public-subnet.1.id}",
  ]
}

resource "aws_alb_target_group" "public-ecs-target-group" {
  name     = "public-ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [
    "aws_alb.public-load-balancer",
  ]

  tags {
    Name = "public-ecs-target-group"
  }
}

resource "aws_alb_listener" "public-alb-listener" {
  load_balancer_arn = "${aws_alb.public-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.public-ecs-target-group.arn}"
    type             = "forward"
  }
}

##############################################################################
# App Servers Load Balancing
##############################################################################
resource "aws_alb" "appservers-load-balancer" {
  name            = "appservers-load-balancer"
  security_groups = ["${aws_security_group.appservers-alb-sg.id}"]

  subnets = [
    "${aws_subnet.private-subnet.0.id}",
    "${aws_subnet.private-subnet.1.id}",
  ]
}

resource "aws_alb_target_group" "appservers-ecs-target-group" {
  name     = "appservers-ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [
    "aws_alb.appservers-load-balancer",
  ]

  tags {
    Name = "appservers-ecs-target-group"
  }
}

resource "aws_alb_listener" "app-alb-listener" {
  load_balancer_arn = "${aws_alb.appservers-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.appservers-ecs-target-group.arn}"
    type             = "forward"
  }
}

##############################################################################
# DB Servers Load Balancing
##############################################################################
resource "aws_alb" "dbservers-load-balancer" {
  name            = "dbservers-load-balancer"
  security_groups = ["${aws_security_group.dbservers-alb-sg.id}"]

  subnets = [
    "${aws_subnet.database-subnet.0.id}",
    "${aws_subnet.database-subnet.1.id}",
  ]
}

resource "aws_alb_target_group" "dbservers-ecs-target-group" {
  name     = "dbservers-ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [
    "aws_alb.dbservers-load-balancer",
  ]

  tags {
    Name = "dbservers-ecs-target-group"
  }
}

resource "aws_alb_listener" "db-alb-listener" {
  load_balancer_arn = "${aws_alb.dbservers-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.dbservers-ecs-target-group.arn}"
    type             = "forward"
  }
}
