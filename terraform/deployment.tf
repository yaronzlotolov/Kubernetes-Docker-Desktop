resource "kubernetes_deployment" "hellowworld" {
    metadata {
        name = "helloworld"
    }
    spec {
        selector {
            match_labels = {
                "app" = "helloworld"
            }
        }
        replicas = 2
        template {
            metadata {
                labels = {
                    "app" = "helloworld"
                }
            }
            spec {
                container {
                    name = "helloworld"
                    image = "kartthequian/helloworld:latest"
                    port {
                        container_port = 80
                    }
                }
            }
        }
    }
}

