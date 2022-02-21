# クライアントにIngressで公開するバージョン

# MySQLのPodの立ち上げ
kubectl apply -f ./volume
kubectl apply -f ./mysql

# mysqlのPodたちがReady状態になるのを待つ
kubectl wait --for=condition=Ready pod/mysql-2 --timeout 200s

# APIのPodの立ち上げ
kubectl apply -f ./api

# APIのPodがReady状態になるのを待つ
kubectl wait pods --for=condition=Ready -l app=goapi --timeout 200s

# フロントエンドのPodの立ち上げ
kubectl apply -f ./client/nginx-config.yml
kubectl apply -f ./client/nginx-deployment.yml
kubectl apply -f ./client/ingress.yml