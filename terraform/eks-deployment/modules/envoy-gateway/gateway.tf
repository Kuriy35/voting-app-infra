resource "helm_release" "envoy_gateway" {
  name       = "envoy-gateway"
  namespace  = "kube-system"
  repository = "oci://docker.io/envoyproxy"
  chart      = "gateway-helm"
  version    = "1.7.1"

  values = [yamlencode({
    deployment = {
      replicas = 1
      envoyGateway = {
        resources = {
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }
          limits = {
            memory = "512Mi"
          }
        }
      }
    }
  })]

  wait    = true
  timeout = 600
}
