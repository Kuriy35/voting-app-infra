include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/envoy-gateway"
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
