data "aws_caller_identity" "current" {}

resource "random_string" "webhook_secret_random" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "github_token_param" {
  name        = "/eks/github_token_param"
  description = "parameter to store github token"
  type        = "SecureString"
  value       = var.github_token
}

module eks-pipeline-policy {
  source = "../../terraform-modules/terraform-module-aws-iam-policy/"

  policy_name        = "codepipeline-policy"
  policy_description = "Policy for AWS codepipeline"
  policy_document    = file("${path.module}/policies/codepipeline-policy.json")
}

module eks_codepipeline_role {
  source = "../../terraform-modules/terraform-module-aws-iam-role/"

  iam_role_name        = "eks_pipeline_role"
  iam_role_description = "role for EKS pipeline"
  assume_role_policy   = file("${path.module}/policies/assume-role-codepipeline.json")
  iam_policy_arns      = [module.eks-pipeline-policy.policy_arn]
}

module eks-codebuild-policy {
  source = "../../terraform-modules/terraform-module-aws-iam-policy/"

  policy_name        = "codebuild-policy"
  policy_description = "Policy for AWS codebuild"
  policy_document    = file("${path.module}/policies/codebuild-policy.json")
}

module eks_codebuild_role {
  source = "../../terraform-modules/terraform-module-aws-iam-role/"

  iam_role_name        = "eks_codebuild_role"
  iam_role_description = "role for EKS codebuild"
  assume_role_policy   = file("${path.module}/policies/assume-role-codebuild.json")
  iam_policy_arns      = [module.eks-codebuild-policy.policy_arn]
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.artifact_s3_bucket
  acl    = "private"
}


resource "aws_codepipeline_webhook" "webhook" {
  name            = "eks-webhook-github"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.ekspipeline.name

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

/*
resource "github_repository_webhook" "aws_codepipeline" {
  repository = var.github_repo

  configuration {
    url          = aws_codepipeline_webhook.webhook.url
    content_type = "json"
    insecure_ssl = "true"
    secret       = local.webhook_secret
  }

  events = ["push"]
}
*/

resource "aws_codepipeline" "ekspipeline" {
  name     = var.pipeline_name
  role_arn = module.eks_codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  tags = local.pipeline_tags
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }
  
  stage {
    name = "DockerBuildAndPush"

    action {
      name             = "DockerBuildAndPush"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.eks_codebuild_project.name

        EnvironmentVariables = jsonencode(local.docker_build_env_vars)


      }

    }
  }

}

resource "aws_codebuild_project" "eks_codebuild_project" {
  name         = "eks-docker-build-project"
  description  = "To build and push docker images to ecr"
  service_role = module.eks_codebuild_role.iam_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.docker_build_cwlogs_group
      stream_name = "eks"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-docker.yml"
    auth {
      type = "OAUTH"
    }
  }

  source_version = "master"


}
