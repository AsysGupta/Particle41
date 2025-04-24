variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Mutability setting for tags (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "encryption_type" {
  description = "Encryption type for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS Key ID for encrypting images (only if encryption_type is KMS)"
  type        = string
  default     = ""
}

variable "lifecycle_policy" {
  description = "ECR lifecycle policy (JSON structure)"
  type        = any
  default     = null
}

variable "repository_policy" {
  description = "ECR repository policy (JSON structure)"
  type        = any
  default     = null
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
