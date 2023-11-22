resource "aws_ecr_repository" "ecr_repo" {
  name                  = "${local.name_prefix}-ecr"
  tags                  = merge(var.tags)
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository            = aws_ecr_repository.ecr_repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images if number of image count goes beyond 50",
            "selection": {
				"countType": "imageCountMoreThan",
				"countNumber": 50,
				"tagStatus": "any"
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}