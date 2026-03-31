include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/eks"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    public_subnet_ids  = ["0.0.0.0/0-mock", "1.0.0.0/0-mock"]
    private_subnet_ids = ["2.0.0.0/0-mock", "3.0.0.0/0-mock"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "output"]
}

inputs = {
  cluster_version    = "1.31"
  public_subnet_ids  = dependency.network.outputs.public_subnet_ids
  private_subnet_ids = dependency.network.outputs.private_subnet_ids
  instance_types     = ["t3.small"]
  project_id         = local.env_vars.locals.project_id
  env                = local.env_vars.locals.env
}