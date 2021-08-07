rem *** create namespace argocd***
kubectl create ns argocd
pause

rem *** install argocd ***
cd C:\Kubernetes\Kubernetes-Docker-Desktop\argocd
kubectl apply -n argocd -f install.yml
rem kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.5/manifests/install.yaml
pause

kubectl get all -n argocd
pause

kubectl -n argocd edit svc argocd-server
rem change from ClusterIP to NodePort
kubectl get svc -n argocd
rem get the port for argocd url from argocd-server service (now it is nodeport)
pause

rem *** get login password and decode base64***
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
decode the password here: https://www.base64decode.org/

rem *** login argocd ***
kubectl get svc -n argocd
http://localhost:port
user:admin 
password: decoded password

rem **** add github repository and path to deployment
rem **** sync github with local deployment

rem *** scale up employee deploy to 2
kubectl -n employee scale deploy employee-deployment --replicas 2
pause
kubectl get all -n employee
pause
see in https://localhost:31927/applications/employees?operation=false that employee has 2 pods
rem sync
rem the number of employee pods is 1