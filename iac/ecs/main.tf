data "aws_region" "current" {}

################# CLUSTER ##############################
resource "aws_ecs_cluster" "cluster" {
    name                  = "${local.name_prefix}-ecs-cluster"
    tags                  = merge(var.tags)
    setting {
    name                  = "containerInsights"
    value                 = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_def" {
    family                = "${local.name_prefix}-task-definition"
    task_role_arn         = var.ecs_task_role_arn
    execution_role_arn    = var.ecs_execution_role_arn
    cpu                   = "1024"
    memory                = "3072"
    network_mode          = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions = <<DEFINITION
[
  {
    "name": "${local.name_prefix}",
    "image": "grafana/grafana-oss:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol":"tcp"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${local.region_name}",
          "awslogs-group": "${local.name_prefix}-logs",
          "awslogs-stream-prefix": "${local.name_prefix}"
    },
        "max-size": "10m",
        "max-file": "5",
        "tag": "{{.ID}}"
    },
    "environment": [
        {
            "name": "ENV",
            "value": "dev"
        }
      ],
    "secrets": []
    }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  	name                  = "${local.name_prefix}-ecs-service"
  	cluster               = aws_ecs_cluster.cluster.id
    task_definition       = aws_ecs_task_definition.task_def.arn
    launch_type           = "FARGATE"

  	desired_count         = var.dcc
  	deployment_minimum_healthy_percent  = 100
      deployment_maximum_percent        = 200
      health_check_grace_period_seconds = 20
      load_balancer {
    	target_group_arn    = var.alb_tg_arn
    	container_port      = 3000
    	container_name      = local.name_prefix
	 }
   network_configuration {
     subnets = var.private_subnet_ids
     security_groups = var.security_groups
   }
   deployment_circuit_breaker {
      enable = true
      rollback = true
    }
    tags                  = merge(var.tags)
}



############ SERVICE AUTOSCALING POLICY  #####################
resource "aws_appautoscaling_target" "as_ecs_target_tutorplus-grafana" {
  max_capacity            = var.max_cc
  min_capacity            = var.min_cc
  resource_id             = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"
}

resource "aws_appautoscaling_policy" "asp_target_cpu_tutorplus-grafana" {
  name                    = "asp_target_cpu"
  policy_type             = "TargetTrackingScaling"
  resource_id             = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value          = 60
    scale_in_cooldown     = 60
    scale_out_cooldown    = 60
   }
}

resource "aws_appautoscaling_policy" "asp_target_memory_tutorplus-grafana" {
  name                    = "asp_target_memory"
  policy_type             = "TargetTrackingScaling"
  resource_id             = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value          = 70
    scale_in_cooldown     = 60
    scale_out_cooldown    = 60
   }
}

resource "aws_appautoscaling_policy" "asp_target_request_count_tutorplus-grafana" {
  name                    = "asp_target_request_count"
  policy_type             = "TargetTrackingScaling"
  resource_id             = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = var.resource_label
    }

    target_value          = 800
    scale_in_cooldown     = 65
    scale_out_cooldown    = 60
   }
}