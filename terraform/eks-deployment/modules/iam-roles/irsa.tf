resource "aws_iam_policy" "lb_controller" {
  name   = "${var.cluster_name}-lb-controller"
  policy = file("${path.module}/policies/lb-controller-policy.json")
}

resource "aws_iam_role" "lb_controller" {
  name = "${var.cluster_name}-lb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sts:AssumeRoleWithWebIdentity"
      ]
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${trimprefix(var.oidc_issuer, "https://")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${trimprefix(var.oidc_issuer, "https://")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lb_controller" {
  role       = aws_iam_role.lb_controller.name
  policy_arn = aws_iam_policy.lb_controller.arn
}


resource "aws_secretsmanager_secret" "duckdns_token" {
  name = "${var.project_id}-${var.env}-duckdns-token"

  recovery_window_in_days = 0
}

resource "aws_iam_policy" "external_secrets_operator" {
  name = "${var.cluster_name}-external-secrets-operator"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = ["${aws_secretsmanager_secret.duckdns_token.arn}"]
      }
    ]
  })
}

resource "aws_iam_role" "external_secrets_operator" {
  name = "${var.cluster_name}-external-secrets-operator"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRoleWithWebIdentity"
        ]
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${trimprefix(var.oidc_issuer, "https://")}:sub" = "system:serviceaccount:cert-manager:external-secrets-sa"
            "${trimprefix(var.oidc_issuer, "https://")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_operator" {
  role       = aws_iam_role.external_secrets_operator.name
  policy_arn = aws_iam_policy.external_secrets_operator.arn
}
