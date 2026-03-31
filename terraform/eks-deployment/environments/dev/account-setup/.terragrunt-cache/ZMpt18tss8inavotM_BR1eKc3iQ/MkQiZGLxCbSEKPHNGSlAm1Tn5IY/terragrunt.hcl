include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  project_id = local.env_vars.locals.project_id
  env        = local.env_vars.locals.env
  vpc_cidr   = "10.0.0.0/16"
}