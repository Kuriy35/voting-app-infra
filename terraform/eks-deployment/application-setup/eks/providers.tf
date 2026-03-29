provider "aws" {
  region  = var.aws_region
  profile = "kuriy"

  default_tags {
    tags = {
      Project     = var.project_id
      Environment = var.env
      ManagedBy   = "Terraform"
    }
  }
}
