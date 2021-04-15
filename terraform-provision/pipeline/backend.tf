terraform {
  backend "s3" {
    bucket = "demo-api-deloitte"
    key    = "pipeline/pipeline.tfstate"
    region = "eu-west-1"
  }
}
