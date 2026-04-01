include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/iam-roles"
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name      = "cluster-name-mock"
    oidc_issuer       = "oidc-issuer-mock"
    oidc_provider_arn = "oidc-provider-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  project_id        = local.env_vars.locals.project_id
  env               = local.env_vars.locals.env
  cluster_name      = dependency.eks.outputs.cluster_name
  oidc_issuer       = dependency.eks.outputs.oidc_issuer
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
}