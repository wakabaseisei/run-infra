# クライアントにIngressで公開するバージョン

# MySQLのPodの立ち上げ
kubectl apply -f ./volume
kubectl apply -f ./mysql

# mysqlのPodたちがReady状態になるのを待つ
kubectl wait all -l app=mysql --for condition=Ready --timeout 200s

# APIのPodの立ち上げ
kubectl apply -f ./api

# APIのPodがReady状態になるのを待つ
kubectl wait all -l app=goapi --for condition=Ready --timeout 120s

# フロントエンドのPodの立ち上げ
kubectl apply -f ./client/nginx-config.yml
kubectl apply -f ./client/nginx-deployment.yml
kubectl apply -f ./client/ingress.yml