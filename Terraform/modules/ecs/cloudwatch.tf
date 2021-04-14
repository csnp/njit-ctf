resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs/${var.environment}/backend"

  tags = {
    Environment = var.environment
  }
}
resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs/${var.environment}/nginx"

  tags = {
    Environment = var.environment
  }
}