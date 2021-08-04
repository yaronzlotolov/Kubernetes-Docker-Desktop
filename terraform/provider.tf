
# Configure Kubernetes provider and connect to the Kubernetes API server
# kubectl config view (to get the host url)
# where terraform  (find terraform.exe)
provider "kubernetes" {
  host = "https://kubernetes.docker.internal:6443"
  config_context_auth_info = "docker-for-desktop"
  config_context_cluster   = "docker-for-desktop-cluster"
}

