
resource "aws_ecs_service" "backend" {
  depends_on                        = [aws_lb_listener.backend, aws_lb_listener.backend-https]
  name                              = "${var.environment}-backend"
  cluster                           = aws_ecs_cluster.cluster.arn
  task_definition                   = aws_ecs_task_definition.backend.arn
  launch_type                       = var.network_mode == "awsvpc" ? "FARGATE" : "EC2"
  desired_count                     = 1
  platform_version                  = var.network_mode == "awsvpc" ? "LATEST" : null
  enable_ecs_managed_tags           = false
  health_check_grace_period_seconds = 10

  network_configuration {
    security_groups  = [aws_security_group.backend.id]
    subnets          = data.aws_subnet_ids.private_subnets.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "nginx"
    container_port   = 80
  }

  # needed when using autoscaling 
  lifecycle {
    ignore_changes = [desired_count]
  }
}