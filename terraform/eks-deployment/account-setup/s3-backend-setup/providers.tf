provider "aws" {
  region  = var.aws_region
  profile = "kuriy"

  default_tags {
    tags = {
      Project   = "voting-app-eks"
      ManagedBy = "Terraform"
    }
  }
}
