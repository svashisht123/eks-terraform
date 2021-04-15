terraform {
  backend "s3" {
    bucket         = "demo-api-deloitte"
    key            = "vpc/vpc.tfstate"
    region         = "eu-west-1"
  }
}
