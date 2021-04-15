variable "pipeline_name" {
  type    = string
  default = "eks-helm-build-pipeline"
}

variable "artifact_s3_bucket" {
  type    = string
  default = "demo-eks-s3-bucket"
}

variable "docker_build_cwlogs_group" {
  type    = string
  default = "eks-docker-build-logs"
}

variable "helm_values_cwlogs_group" {
  type    = string
  default = "eks-helm-values-logs"
}

variable "github_owner" {
  type    = string
  default = "svashisht123"
}
variable "github_owner_email" {
  type    = string
  default = "shreya2k@gmail.com"
}
variable "github_repo" {
  type    = string
  default = "api-eks"
}
variable "github_branch" {
  type    = string
  default = "main"
}

locals {
  webhook_secret = random_string.webhook_secret_random.result
}

variable "github_token" {
  type    = string 
}

variable "docker_build_envmap" {
  type = map
  default = {
    "AWS_ACCOUNT_ID"  = "754180621461"
    "PYTHON_ECR_REPO" = "app"
  }
}

locals {
  docker_build_env_vars = [
    {
        name  = "AWS_ACCOUNT_ID"
        type  = "PLAINTEXT"
        value = data.aws_caller_identity.current.account_id
                
    },
    {
        name  = "PYTHON_ECR_REPO"
        type  = "PLAINTEXT"
        value = "app"
                
    }
  ]

}


locals {
  pipeline_tags = {
        "Name"  = var.pipeline_name
      
                
    }  
}
