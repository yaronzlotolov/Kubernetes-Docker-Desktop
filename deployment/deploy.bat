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


rem *** deploy MSSQl with secret and persistent volume ***
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
dotnet vuild
pause
dotnet run
pause
http://localhost:5000/
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
kubectl apply -f .\netcore-deploy-with-ingress-nginx.yml
pause
kubectl get all -n employee
pause

rem *** monitoring - install Chocolaty for kubernetes helm repo for prometheus-operator *** 
helm install prometheus stable/prometheus-operator
kubectl apply -f .\prometheus-ingress-controller.yml