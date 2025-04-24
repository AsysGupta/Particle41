variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "encryption_type" {
  description = "Encryption type (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (required if encryption_type is KMS)"
  type        = string
  default     = ""
}

variable "lifecycle_policy" {
  description = "Lifecycle policy document"
  type        = any
  default     = null
}

variable "repository_policy" {
  description = "Repository policy document"
  type        = any
  default     = null
}

variable "tags" {
  description = "Tags for the repository"
  type        = map(string)
  default     = {}
}
