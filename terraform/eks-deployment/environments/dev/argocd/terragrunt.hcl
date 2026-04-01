include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/argocd"
}

dependency "vpc" {
  config_path = "../account-setup"
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    public_subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
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
    lb_controller_role_arn             = "lb-controller-arn-mock"
    external_secrets_operator_role_arn = "eso-arn-mock"
    duckdns_token_secret_name          = "secret-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependencies {
  paths = ["../lb-controller"]
}

generate "k8s_provider" {
  path      = "k8s_provider.tf"
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

provider "kubectl" {
  host                   = "${dependency.eks.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_ca_certificate}")
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
EOF
}

inputs = {
  project_id                         = local.env_vars.locals.project_id
  env                                = local.env_vars.locals.env
  git_repo_url                       = "https://github.com/Kuriy35/voting-app-infra.git"
  vpc_id                             = dependency.vpc.outputs.vpc_id
  public_subnet_ids                  = dependency.network.outputs.public_subnet_ids
  cluster_name                       = dependency.eks.outputs.cluster_name
  lb_controller_role_arn             = dependency.iam_roles.outputs.lb_controller_role_arn
  external_secrets_operator_role_arn = dependency.iam_roles.outputs.external_secrets_operator_role_arn
  duckdns_token_secret_name          = dependency.iam_roles.outputs.duckdns_token_secret_name
}