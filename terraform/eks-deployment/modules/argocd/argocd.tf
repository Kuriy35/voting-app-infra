resource "helm_release" "argocd" {
  name             = "${var.project_id}-${var.env}-argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "9.4.17"

  values = [yamlencode({
    global = {
      domain = ""
    }

    configs = {
      params = {
        "server.insecure" = true
      }
    }

    server = {
      ingress = {
        enabled          = true
        controller       = "aws"
        ingressClassName = "alb"
        hostname         = ""
        annotations = {
          "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
          "alb.ingress.kubernetes.io/target-type"      = "ip"
          "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
          "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
        }
        aws = {
          serviceType            = "ClusterIP"
          backendProtocolVersion = "HTTP1"
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
  timeout = 600
}

resource "kubectl_manifest" "application" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_url
        targetRevision = "main"
        path           = "terraform/eks-deployment/gitops/root-app"

        helm = {
          valuesObject = {
            clusterName = var.cluster_name
            vpcId       = var.vpc_id
            externalSecrets = {
              irsaRoleArn = var.external_secrets_operator_role_arn
            }
            duckdns = {
              tokenSecretName = var.duckdns_token_secret_name
            }
          }
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
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
