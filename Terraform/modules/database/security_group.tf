# SG for ALB -> ecs
resource "aws_security_group" "db" {
  name        = "${var.environment}-db"
  description = "Inbound db"
  vpc_id      = data.aws_vpc.current.id
  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    cidr_blocks = [data.aws_vpc.current.cidr_block]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-db"
  }
}
