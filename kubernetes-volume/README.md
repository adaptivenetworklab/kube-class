# Kubenetes Volume 

By default containers store their data on the file system like any other process.
Container file system is temporary and not persistent during container restarts
When container is recreated, so is the file system


Same can be demonstrated using Kubernetes

```
cd ./kubernetes-volume/

kubectl create ns postgres
kubectl apply -n postgres -f ./postgres-no-pv.yaml
kubectl -n postgres get pods 
kubectl -n postgres exec -it postgres-0 -- bash

# login to postgres
psql --username=admin postgresdb

#create a table
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);

#show table
\dt

# quit 
\q

# redeploy (data hilang)

kubectl delete po -n postgres postgres-0
kubectl apply -n postgres -f ./postgres-no-pv.yaml

```

### Persist data Kubernetes


```
kubectl apply -f persistentvolume.yaml
kubectl apply -n postgres -f persistentvolumeclaim.yaml

kubectl delete -f persistentvolume.yaml
kubectl delete -n postgres -f persistentvolumeclaim.yaml

kubectl apply -n postgres -f postgres-with-pv.yaml

kubectl -n postgres get pods 
kubectl -n postgres exec -it postgres-0 -- bash

# login to postgres
psql --username=admin postgresdb

#create a table
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);

#show table
\dt

# quit 
\q

# redeploy (data hilang)

kubectl delete -n postgres -f ./postgres-with-pv.yaml
kubectl apply -n postgres -f ./postgres-with-pv.yaml

kubectl -n postgres get pods

```

### Referensi 

https://youtu.be/ZxC6FwEc9WQ
