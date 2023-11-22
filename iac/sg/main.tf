resource "aws_security_group" "alb" {

  name                  = "${local.name_prefix}-alb-sg"
  vpc_id                = var.vpc_id
  ingress {
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    }

  ingress {
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    }

  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  tags                  = merge(var.tags)
}

resource "aws_security_group" "ecs" {

  name                  = "${local.name_prefix}-ec2-sg"
  vpc_id                = var.vpc_id
  ingress {
    from_port           = 0
    to_port             = 65535
    protocol            = "tcp"
    security_groups     = ["${aws_security_group.alb.id}"]
  }
  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  tags                  = merge(var.tags)
}