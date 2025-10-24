echo '-------Deploy a PostgreSQL sample database'

kubectl create namespace yong-postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install --namespace yong-postgresql postgres bitnami/postgresql \
  --set image.tag=16.3.0-debian-12-r20 \
  --set primary.persistence.size=1Gi
kubectl -n yong-postgresql annotate pod/postgres-postgresql-0 backup.velero.io/backup-volumes=data