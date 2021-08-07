# Deploy .NET 5.0 Web application with MSSQL to Kubernetes Cluster using Docker Desktop for Windows 10.
The deployment requires Windows 10 latest version, WSL v2,
Ubuntu 20.04 TLS distros, Docker-Desktop,
.Net 5.0, Entity Framework Core, Visual Studio Code
and Git.

The example contains kubernetes components like deployments,
pods, services, replicaset, secrets, persistent volume, ingress and
prometheus. This example runs CI that creates a docker image and pushes it to DockerHub using github actions.
The CD is controlled by argocd gitops.
Instructions are located in Documents folder in the code.
