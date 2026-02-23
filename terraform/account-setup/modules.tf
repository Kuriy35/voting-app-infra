module "vpc_setup" {
  source     = "./modules/vpc"
  project_id = var.project_id
  vpc_cidr   = var.vpc_cidr
  env        = var.env
}
