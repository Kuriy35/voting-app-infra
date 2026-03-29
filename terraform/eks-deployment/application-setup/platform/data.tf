data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "voting-app-terraform-backend"
    key    = "application-setup/eks/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "voting-app-terraform-backend"
    key    = "account-setup/terraform.tfstate"
    region = "us-east-1"
  }
}
