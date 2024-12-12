resource "random_password" "grafana_admin_password" {
  length           = 12
  special          = true
  override_special = "!@#$%^&*()"
}

resource "kubernetes_secret" "grafana_admin_password" {
  metadata {
    name      = "grafana-admin-password"
    namespace = "monitoring"
  }
  type = "Opaque"
  data = {
    password = random_password.grafana_admin_password.result
  }
}
