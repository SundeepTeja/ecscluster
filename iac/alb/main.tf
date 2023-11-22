#### external ALB ###########
resource "aws_lb" "alb" {
  name                        = "${local.name_prefix}-alb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = var.security_groups
  subnets                     = var.public_subnet_ids
  enable_deletion_protection  = false
  tags                        = merge(var.tags)
}

resource "aws_lb_target_group" "tg" {
  name                        = "${local.name_prefix}-tg"
  port                        = "80"
  protocol                    = "HTTP"
  target_type                 = "ip"
  vpc_id                      = var.vpc_id
  deregistration_delay        = 60
  health_check {
    healthy_threshold         = 2
    interval                  = 15
    path                      = "/"
    timeout                   = 10
    unhealthy_threshold       = 5
    matcher                   = "200-499"
    }
  lifecycle {
    create_before_destroy     = true
  }
  tags                        = merge(var.tags)
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn           = aws_lb.alb.arn
  port                        = "443"
  protocol                    = "HTTPS"
  ssl_policy                  = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn             = var.alb_certificate_arn
  default_action {
    target_group_arn          = aws_lb_target_group.tg.arn
    type                      = "forward"
  }
  lifecycle {
    create_before_destroy     = true
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn           = aws_lb.alb.arn
  port                        = "80"
  default_action {
    type                      = "redirect"
  redirect {
      port                    = "443"
      protocol                = "HTTPS"
      status_code             = "HTTP_301"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "path_based_routing" {
  listener_arn                = aws_lb_listener.alb_listener.arn
  priority                    = 1

  action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.tg.arn
  }
  condition {
    path_pattern {
      values =                ["/*"]
    }
  }
}

