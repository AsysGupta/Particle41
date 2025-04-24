module "ecr" {
  source = "../modules/ecr"

  repo_name            = var.repo_name
  scan_on_push         = var.scan_on_push
  image_tag_mutability = var.image_tag_mutability
  encryption_type      = var.encryption_type
  kms_key_id           = var.kms_key_id
  lifecycle_policy     = var.lifecycle_policy
  repository_policy    = var.repository_policy
  tags                 = var.tags
}


