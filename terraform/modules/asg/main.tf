resource "aws_launch_template" "app" {
  name_prefix   = "app-launch-template"
  image_id      = "ami-0c55b159cbfafe1f0" # Cambiar esto por AMI
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_role.ec2_role.name
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size     = 2
  max_size     = 4
  desired_capacity = 2
  vpc_zone_identifier = aws_subnet.private[*].id

  tag {
    key                 = "Name"
    value               = "AppServer"
    propagate_at_launch = true
  }
}
