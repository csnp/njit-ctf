
locals {
  container_definition = [
    {
      name                   = "ctfd"
      networkMode            = var.network_mode
      image                  = "${aws_ecr_repository.ecr.repository_url}:${var.image_tag}"
      essential              = var.essential
      readonlyRootFilesystem = var.readonly_root_filesystem
      portMappings           = var.port_mappings
      # memory                 = var.container_memory
      # cpu                    = var.container_cpu
      environment            = var.container_environment
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name                   = "nginx"
      networkMode            = var.network_mode
      image                  = "${aws_ecr_repository.nginx.repository_url}:latest"
      essential              = var.essential
      readonlyRootFilesystem = var.nginx_readonly_root_filesystem
      portMappings           = var.nginx_port_mappings
      # memory                 = var.nginx_container_memory
      # cpu                    = var.nginx_container_cpu
      environment            = var.nginx_container_environment
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nginx.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ]

  json_data = jsonencode(local.container_definition)
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.environment}-backend"
  container_definitions    = local.json_data
  requires_compatibilities = var.network_mode == "awsvpc" ? ["FARGATE"] : ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  network_mode             = var.network_mode
  memory                   = var.container_memory
  cpu                      = var.container_cpu
}
