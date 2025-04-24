resource "aws_ecr_repository" "this" {
  name                 = var.repo_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  image_tag_mutability = var.image_tag_mutability
  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key_id != "" ? var.kms_key_id : null
  }
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.lifecycle_policy != null ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = jsonencode(var.lifecycle_policy)
}

resource "aws_ecr_repository_policy" "this" {
  count = var.repository_policy != null ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = jsonencode(var.repository_policy)
}
