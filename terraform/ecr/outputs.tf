output "repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "ECR Repository ARN"
  value       = module.ecr.repository_arn
}

output "repository_name" {
  description = "ECR Repository Name"
  value       = module.ecr.repository_name
}
