data "aws_caller_identity" "current" {}

data "aws_vpc" "current" {
  tags = {
    Environment = var.environment
  }
}
data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.current.id
  tags = {
    Tier = "private"
  }
}
data "aws_security_group" "selected" {
  name = "${var.environment}-ecs-backend"
}