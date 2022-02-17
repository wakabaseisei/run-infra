kubectl apply -f mysql-configmap.yml
kubectl apply -f mysql-services.yml
kubectl apply -f nginx-config.yml
kubectl apply -f mysql-secret.yml
kubectl apply -f storageClass.yml 