variable "region" {
  default = "eu-west-1"
}

variable "enable_ssh" {
  type = bool
  default = true
}

variable "sshkey" {
  default = "eksshreya"
}

variable "ecr_repo_list" {
  description = "ECR repo name list"
  type = list(string)

  default = ["eks/python"]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::754180621461:user/shreya"
      username = "Shreya"
      groups   = ["system:masters"]
    }

  ]
}

#variable "map_roles" {
#  description = "Additional IAM roles to add to the aws-auth configmap."
#  type = list(object({
#    rolearn  = string
#    username = string
#    groups   = list(string)
#  }))
#
#}

locals {
  
  asg_tags = [ 
  {
     "key": "k8s.io/cluster-autoscaler/enabled",
     "propagate_at_launch": true,
     "value": true
  },
  {
     "key": "k8s.io/cluster-autoscaler/demo-api-cluster",
     "propagate_at_launch": true,
     "value": "owned"
  }]
  
}
