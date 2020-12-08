resource "aws_key_pair" "ec2_kp" {
  key_name   = "inkstom_kp"
  public_key = file(var.pub_key_path)
}

# Create a new instance of latest Amazon Linux 2

data "aws_ami" "amzn-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200904.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "amzn-lin-01" {
  ami                    = data.aws_ami.amzn-2.id
  instance_type          = "t2.micro"
  key_name               = "inkstom_kp"
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  #  provisioner "remote-exec" {
  #    inline = [
  #      "sudo yum update && sudo yum upgrade",
  #      "sudo systemctl start crond",
  #      "sudo systemctl enable crond",
  #      "sudo yum install docker git -y",
  #      "sudo systemctl start docker.service",
  #      "sudo systemctl enable docker.service",
  #      "git clone https://github.com/CitrineInformatics/sample-service.git"
  #    ]
  #  }

  #  provisioner "file" {
  #    source      = "script.sh"
  #    destination = "~/script.sh"
  #  }

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu-01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "inkstom_kp"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
}

resource "aws_lb" "alb" {
  name               = "alb-01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb-01"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name                 = "tg-01"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.org_vpc.id
  deregistration_delay = 30
  health_check {
    healthy_threshold   = 2
    interval            = 15
    path                = "/healthcheck"
    timeout             = 10
    unhealthy_threshold = 2
    matcher             = "200-499"
  }
  tags = {
    Name = "tg-01"
  }
}

resource "aws_lb_listener" "alb_lis" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}
