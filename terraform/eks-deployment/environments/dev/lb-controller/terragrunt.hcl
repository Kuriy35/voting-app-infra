include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/lb-controller"
}

dependency "vpc" {
  config_path = "../account-setup"
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name           = "mock-cluster"
    cluster_endpoint       = "endpoint-mock"
    cluster_ca_certificate = "ZHVtbXk="
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "iam_roles" {
  config_path = "../iam_roles"
  mock_outputs = {
    lb_controller_role_arn = "lb-controller-arn-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster_auth" "cluster" {
  name = "${dependency.eks.outputs.cluster_name}"
}

provider "helm" {
  kubernetes = {
    host                   = "${dependency.eks.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_ca_certificate}")
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
EOF
}

inputs = {
  vpc_id                 = dependency.vpc.outputs.vpc_id
  cluster_name           = dependency.eks.outputs.cluster_name
  lb_controller_role_arn = dependency.iam_roles.outputs.lb_controller_role_arn
}