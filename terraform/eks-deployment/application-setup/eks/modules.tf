module "network" {
  source                     = "./modules/network"
  vpc_id                     = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_cidr_blocks  = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_azs          = ["us-east-1a", "us-east-1b"]
  private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_azs         = ["us-east-1a", "us-east-1b"]
  project_id                 = var.project_id
  env                        = var.env
}

module "eks" {
  source             = "./modules/eks"
  cluster_version    = "1.31"
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  instance_types     = ["t3.small"]
  project_id         = var.project_id
  env                = var.env
}
