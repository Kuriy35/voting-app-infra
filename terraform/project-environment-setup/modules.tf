module "network" {
  source              = "./modules/network"
  vpc_id              = data.aws_vpc.vpc.id
  availability_zones  = var.availability_zones
  env                 = var.env
  project_id          = var.project_id
  public_cidr_blocks  = var.public_cidr_blocks
  private_cidr_blocks = var.private_cidr_blocks
}

module "application" {
  source                  = "./modules/application-setup"
  vpc_id                  = data.aws_vpc.vpc.id
  ami_id                  = data.aws_ami.latest_amazon_linux.id
  env                     = var.env
  project_id              = var.project_id
  public_subnet_ids       = module.network.public_subnet_ids
  private_subnet_ids      = module.network.private_subnet_ids
  db_name                 = var.db_name
  db_username             = var.db_username
  db_availability_zone    = var.db_availability_zone
  postgres_engine_version = data.aws_rds_engine_version.postgres_engine_version.version
  public_key              = var.public_key
}
