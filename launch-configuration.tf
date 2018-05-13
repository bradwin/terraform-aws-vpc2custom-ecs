resource "aws_launch_configuration" "webserver-ecs-launch-configuration" {
  name                 = "webserver-ecs-launch-configuration"
  image_id             = "${lookup(var.ecs_ami, var.region)}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.webserver-sg.id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${lookup(var.ecs_cluster_names, "public")} >> /etc/ecs/ecs.config
EOF
}

resource "aws_launch_configuration" "appserver-ecs-launch-configuration" {
  name                 = "appserver-ecs-launch-configuration"
  image_id             = "${lookup(var.ecs_ami, var.region)}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.appserver-sg.id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${lookup(var.ecs_cluster_names, "appserver")} >> /etc/ecs/ecs.config
EOF
}

resource "aws_launch_configuration" "dbserver-ecs-launch-configuration" {
  name                 = "dbserver-ecs-launch-configuration"
  image_id             = "${lookup(var.ecs_ami, var.region)}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.dbserver-sg.id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${lookup(var.ecs_cluster_names, "dbserver")} >> /etc/ecs/ecs.config
EOF
}
