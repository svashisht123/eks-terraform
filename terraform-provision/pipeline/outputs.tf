
output "codepipeline_artifact_bucket" {
  description = "Codepipeline s3 artifact bucket"
  value       = aws_s3_bucket.codepipeline_bucket
}