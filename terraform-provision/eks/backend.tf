terraform {
  backend "s3" {
    bucket         = "demo-api-deloitte"
    key            = "eks/eks.tfstate"
    region         = "eu-west-1"
  }
}
