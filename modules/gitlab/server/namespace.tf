resource "kubernetes_namespace" "gitlab_namespace" {
  metadata {
    name = var.gitlab_namespace
  }
}