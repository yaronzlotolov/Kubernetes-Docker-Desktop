rem *** Clean up kuberneties name sapce, docker images and containers and login to docker hub ***
rem docker system prune -a
rem kubectl delete ns employee
rem resore to factory defualts from Troubleshoot icon in deocker desktop

rem *** the mnifest are here ***
cd C:\Project\Kubernetes-Docker-Desktop\deployment


rem *** create employee namespace ***
kubectl create ns employee
pause
kubectl get ns
pause

rem *** create connection string and sa password secrets to MSSQL ***
kubectl create secret generic mssql-secret --namespace=employee --from-literal='ConnectionString="server=mssql-service;Initial Catalog=EmployeeDB;Persist Security Info=False;User ID=sa;Password=MyDemoPwd2021!;MultipleActiveResultSets=true"' --from-literal='SA_PASSWORD=MyDemoPwd2021!'
echo  ****** create secret generic mssql-secret manually!!! *****
pause
rem kubectl create secret generic mssql-secret --namespace=employee --from-literal=ConnectionString=.\cn.txt --from-literal=SA_PASSWORD=.\pass.txt
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
timeout 150
pause

rem *** create EMPLOYEEDB using dotnet ef core (make sure the connection string is updated in Employees\appsettings.json or in Environmet Variables for User)  ***
rem ConnectionStrings__ConnectionString -> server=localhost,1433;Initial Catalog=EmployeeDB;Persist Security Info=False;User ID=sa;Password=MyDemoPwd2021!;MultipleActiveResultSets=true
cd C:\Project\Kubernetes-Docker-Desktop\Employees
dotnet ef database update
pause
rem dotnet build
rem pause
rem dotnet run
rem pause
rem http://localhost:5000/
rem pause

rem *** Create docker image and push it to docker hub ***
rem cd C:\Kubernetes\Kubernetes-Docker-Desktop
rem docker build -t employees:v5 .  
rem pause
rem docker images | more
rem pause
rem docker tag employees:v5 yaronzlotolov/employees:v5
rem pause
rem docker images | more
rem pause
rem docker push yaronzlotolov/employees:v5
rem pause
rem https://hub.docker.com/repository/docker/yaronzlotolov/employees
rem pause

rem *** TLS/SSL certification secret for employee web site in inngress-nginx
cd C:\Project\Kubernetes-Docker-Desktop\certification
kubectl create secret tls employee-secret --key privkey.pem --cert cert.pem -n employee
pause
kubectl get secret employee-secret -n employee -oyaml
pause
kubectl describe secret employee-secret -n employee
pause


rem ** deploy netcore web application with ingress-nginx ***
cd C:\Project\Kubernetes-Docker-Desktop\deployment
pause
kubectl apply -f .\ingress-nginx-deployment.yml
pause
timeout 120
pause
rem check netcore-deploy-with-ingress-nginx.yml -> yaronzlotolov/employees:v5
rem pause
cd C:\Kubernetes\Kubernetes-Docker-Desktop\deployment
docker pull yaronzlotolov/employees:v5
pause
rem Do NOT cd C:\Kubernetes\Kubernetes-Docker-Desktop\Deployment!!!!!!
kubectl apply -f .\netcore-deploy-with-ingress-nginx.yml 
rem sleep 60 sec
pause
kubectl get all -n employee
pause
rem in case of problem restart VScode
rem kubectl delete -f .\netcore-deploy-with-ingress-nginx.yml
pause
rem kubectl get all -n employee
pause
rem kubectl -n employee get deploy employee-deployment -oyaml
rem set netcore-deploy-with-ingress-nginx.yml -> employees:v5
rem docker pull yaronzlotolov/employees:v5
rem kubectl describe -n employee pod/employee-deployment-59db54f94c-gkgj4
pause
rem cd C:\Kubernetes\Kubernetes-Docker-Desktop\deployment
rem kubectl apply -f .\netcore-deploy-with-ingress-nginx.yml 
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
timeout 30
rem C:\Windows\System32\drivers\etc\hosts > 127.0.0.1 prometheus.gui.com 
rem https://prometheus.gui.com/
rem user:admin
rem password: prom-operator
