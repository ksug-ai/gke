echo '-------Deploy a PostgreSQL sample database'

kubectl create namespace yong-postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
if [ ! -f ~/.cache/helm/repository/bitnami-index.yaml ] || [ $(find ~/.cache/helm/repository/bitnami-index.yaml -mtime +7 2>/dev/null | wc -l) -gt 0 ]; then
  helm repo update bitnami
fi
helm install postgres bitnami/postgresql \
  --namespace yong-postgresql \
  --create-namespace \
  --set primary.persistence.size=1Gi \
  --set primary.persistence.labels.created-by=gke-deploy-script \
  --wait --timeout 5m0s
kubectl -n yong-postgresql annotate pod/postgres-postgresql-0 backup.velero.io/backup-volumes=data