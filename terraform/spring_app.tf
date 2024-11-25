# Namespace for the Spring Boot application
resource "kubernetes_namespace" "springboot_app" {
  metadata {
    name = "springboot-app"
  }
}
# ArgoCD Application for the Spring Boot app
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "springboot-app"
      namespace = "argocd-app"
    }
    spec = {
      project = "default"
      source = {
        repoURL = "https://github.com/ons-ou/SpringHelloDevops.git"
        path    = "k8s"
        targetRevision = "HEAD"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.springboot_app.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune = true
          selfHeal = true
        }
      }
    }
  }
}
