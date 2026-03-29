resource "helm_release" "argocd" {
  name             = "${var.project_id}-${var.env}-argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "9.4.17"

  values = [yamlencode({
    server = {
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-scheme"  = "internet-facing"
          "service.beta.kubernetes.io/aws-load-balancer-type"    = "external"
          "service.beta.kubernetes.io/aws-load-balancer-subnets" = join(",", var.public_subnet_ids)
        }
      }
    }
    dex = {
      enabled = false
    }
    notifications = {
      enabled = false
    }
  })]

  wait    = true
  timeout = 300
}

resource "kubectl_manifest" "application" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "${var.project_id}-${var.env}"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_url
        targetRevision = "main"
        path           = "helm-charts/voting-app"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "voting-app"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  })

  depends_on = [helm_release.argocd]
}
