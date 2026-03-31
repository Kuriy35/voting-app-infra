include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/network"
}

dependency "vpc" {
  config_path = "../account-setup"
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  project_id                 = local.env_vars.locals.project_id
  env                        = local.env_vars.locals.env
  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnet_cidr_blocks  = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_azs          = ["us-east-1a", "us-east-1b"]
  private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_azs         = ["us-east-1a", "us-east-1b"]
}