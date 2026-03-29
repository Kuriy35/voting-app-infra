data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "voting-app-terraform-backend"
    key    = "account-setup/terraform.tfstate"
    region = "us-east-1"
  }
}
