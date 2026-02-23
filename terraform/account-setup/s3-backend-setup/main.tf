terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-backend-bucket-voting-app"
    key          = "account-setup/s3-backend-setup/terraform.state"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
