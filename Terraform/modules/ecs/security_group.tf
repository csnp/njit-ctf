# SG for ALB -> ecs
resource "aws_security_group" "backend" {
  name        = "${var.environment}-ecs-backend"
  description = "Inbound ALB"
  vpc_id      = data.aws_vpc.current.id
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb_sg.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-ecs-backend"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-alb"
  description = "Control access to LB"
  vpc_id      = data.aws_vpc.current.id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-lb"
  }
}