resource "aws_ecr_repository" "ecr" {
  name = "${var.environment}-${var.ecr_name}"
}

resource "aws_ecr_lifecycle_policy" "ecrpolicy" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire old images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository" "nginx" {
  name = "${var.environment}-nginx"
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire old images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}