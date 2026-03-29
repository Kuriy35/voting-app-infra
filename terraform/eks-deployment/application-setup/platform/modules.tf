module "argocd" {
  source            = "./modules/argocd"
  project_id        = var.project_id
  env               = var.env
  git_repo_url      = var.git_repo_url
  public_subnet_ids = data.terraform_remote_state.eks.outputs.public_subnet_ids
}

module "lb_controller" {
  source            = "./modules/ingress-controller"
  project_id        = var.project_id
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_name      = data.terraform_remote_state.eks.outputs.eks_cluster_name
  oidc_issuer       = data.terraform_remote_state.eks.outputs.oidc_issuer
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  env               = var.env
}
