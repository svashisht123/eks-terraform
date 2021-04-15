# 1 Create the ECR repo

resource "aws_ecr_repository" "ecr_repo" {
  count      = length(var.ecr_repo_names)
  name                 = var.ecr_repo_names[count.index]
  image_tag_mutability = "MUTABLE"
}

