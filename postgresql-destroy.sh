echo '-------Destroy a PostgreSQL sample database'

helm uninstall postgres -n yong-postgresql --wait
kubectl delete namespace yong-postgresql
