rem copy the demo bak file to data folder

rem *** nevigate to data folder***
cd C:\Kubernetes\Kubernetes-Docker-Desktop\data

rem *** check the mssql pod exists***
kubectl get all -n employee

rem *** copy the bak file into the pod***
kubectl cp Demo15SP4.bak employee/mssql-deployment-5df84d6f57-qbskd:/var/opt/mssql/data/Demo15SP4.bak

rem *** connect to mssql pod***
kubectl -n employee exec -it pod/mssql-deployment-5df84d6f57-qbskd  -- /bin/sh

rem *** check the bak file exists***
ls -ltr /var/opt/mssql/data

rem open Azure Data Studio and connect to mssql 

rem right click on the server (localhost) > manage > restore > restore from backup file > var/opt/mssql/data/demo.bak > restore

rem add extention "Admin Pack for SQL Server" > right click on the server (localhost) > manage > Sql Agent > Jobs
