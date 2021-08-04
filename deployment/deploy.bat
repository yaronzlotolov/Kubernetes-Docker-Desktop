rem *** Clean up kuberneties name sapce, docker images and containers and login to docker hub ***
rem docker system prune -a
rem kubectl delete ns employee
rem resore to factory defualts

rem *** the mnifest are here ***
cd C:\Project\Kubernetes-Docker-Desktop\Deployment


rem *** create employee namespace ***
kubectl create ns employee
pause
kubectl get ns
pause


rem *** create connection string and sa password secrets to MSSQL ***
kubectl create secret generic mssql-secret --namespace=employee --from-literal='ConnectionString="server=mssql-service;Initial Catalog=EmployeeDB;Persist Security Info=False;User ID=sa;Password=MyDemoPwd2021!;MultipleActiveResultSets=true"' --from-literal='SA_PASSWORD=MyDemoPwd2021!'
pause
kubectl get secret mssql-secret -n employee -oyaml
pause


rem *** deploy MSSQl with secret and persistent volume (take few minutes on the first time)***

kubectl apply -f .\mssql-deploy-with-secret-and-pv.yml
pause
kubectl get pods -n employee
pause
kubectl get all -n employee
pause


rem *** create EMPLOYEEDB using dotnet ef core (make sure the connection string is updated in Employees\appsettings.json or in Environmet Variables for User)  ***
rem ConnectionStrings__ConnectionString -> server=localhost,1433;Initial Catalog=EmployeeDB;Persist Security Info=False;User ID=sa;Password=MyDemoPwd2021!!;MultipleActiveResultSets=true
cd C:\Project\Kubernetes-Docker-Desktop\Employees
dotnet ef database update
pause
dotnet build
pause
dotnet run
pause
http://localhost:5000/
pause

rem *** Create docker image and push it to docker hub ***
cd C:\Kubernetes\Kubernetes-Docker-Desktop
docker build -t employees:v5 .  
pause
docker images | more
pause
docker tag employees:v5 yaronzlotolov/employees:v5
pause
docker images | more
pause
docker push yaronzlotolov/employees:v5
pause
https://hub.docker.com/repository/docker/yaronzlotolov/employees
pause

rem *** TLS/SSL certification secret for employee web site in inngress-nginx
cd C:\Project\Kubernetes-Docker-Desktop\certification
kubectl create secret tls employee-secret --key privkey.pem --cert cert.pem -n employee
pause
kubectl get secret employee-secret -n employee -oyaml
pause
kubectl describe secret employee-secret -n employee
pause


rem ** deploy netcore web application with ingress-nginx ***
cd C:\Project\Kubernetes-Docker-Desktop\Deployment
pause
kubectl apply -f .\ingress-nginx-deployment.yml
pause
rem check netcore-deploy-with-ingress-nginx.yml -> yaronzlotolov/employees:v5
pause
kubectl apply -f .\netcore-deploy-with-ingress-nginx.yml 
pause
kubectl get all -n employee
pause
rem in case of problem restart VScode
kubectl delete -f .\netcore-deploy-with-ingress-nginx.yml
pause
kubectl get all -n employee
rem set netcore-deploy-with-ingress-nginx.yml -> employees:v5
rem Run: kubectl describe pod/employee-deployment-59db54f94c-gkgj4 -n employee
pause
kubectl apply -f .\netcore-deploy-with-ingress-nginx.yml 
pause
kubectl get all -n employee
pause
rem C:\Windows\System32\drivers\etc\hosts > 127.0.0.1 employee.management.com
rem employee.management.com


rem *** monitoring - install Chocolaty for kubernetes helm repo for prometheus-operator *** 
helm repo update
pause
helm install prometheus stable/prometheus-operator
pause
kubectl apply -f .\prometheus-ingress-controller.yml
pause
rem C:\Windows\System32\drivers\etc\hosts > 127.0.0.1 prometheus.gui.com 
rem https://prometheus.gui.com/
rem user:admin
rem password: prom-operator
