provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "argocd_app" {
  metadata {
    name = "argocd-app"
  }
}

resource "helm_release" "argocd_app" {
  name       = "argocd-app"
  namespace  = kubernetes_namespace.argocd_app.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.4" 

  depends_on = [kubernetes_namespace.argocd_app]
}

resource "kubernetes_manifest" "argocd_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-metrics"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_server_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-server-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-server-metrics"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_repo_server_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-repo-server-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-repo-server"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_applicationset_controller_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-applicationset-controller-metrics"
      namespace = "argocd-app"
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-applicationset-controller"
        }
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_dex_server_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-dex-server"
      namespace = "argocd-app"
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-dex-server"
        }
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_redis_haproxy_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-redis-haproxy-metrics"
      namespace = "argocd-app"
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-redis-ha-haproxy"
        }
      }
      endpoints = [
        {
          port = "http-exporter-port"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_notifications_controller_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-notifications-controller"
      namespace = "argocd-app"
      labels = {
        release = "prometheus-operator"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-notifications-controller-metrics"
        }
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

