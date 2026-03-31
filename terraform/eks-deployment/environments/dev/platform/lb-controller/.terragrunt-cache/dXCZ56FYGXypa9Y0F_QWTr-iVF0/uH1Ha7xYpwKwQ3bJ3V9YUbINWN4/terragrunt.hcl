include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../../modules/lb-controller"
}

dependency "vpc" {
  config_path = "../../account-setup"
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "eks" {
  config_path = "../../eks"
  mock_outputs = {
    cluster_name           = "cluster-mock"
    cluster_endpoint       = "endpoint-mock"
    cluster_ca_certificate = "ZHVtbXk="
    oidc_issuer            = "oidc-issuer-mock"
    oidc_provider_arn      = "oidc-provider-mock"
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
  project_id        = local.env_vars.locals.project_id
  env               = local.env_vars.locals.env
  vpc_id            = dependency.vpc.outputs.vpc_id
  cluster_name      = dependency.eks.outputs.cluster_name
  oidc_issuer       = dependency.eks.outputs.oidc_issuer
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
}