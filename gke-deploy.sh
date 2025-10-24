set -e

echo '-------Creating a GKE Cluster only (typically in ~5 mins)'
starttime=$(date +%s)
. ./setenv.sh
TEMP_PREFIX=$(whoami | sed -e 's/[_.]//g' | tr '[:upper:]' '[:lower:]')
FIRST2=$(printf "%.2s" "$TEMP_PREFIX")
LAST2=$(echo -n "$TEMP_PREFIX" | tail -c2)
MY_PREFIX="$FIRST2$LAST2"
GKE_K8S_VERSION=$(gcloud container get-server-config --region "${MY_REGION}" --format='table(channels.validVersions[])' --filter='channels.channel=RAPID' | grep -o "${K8S_VERSION}-gke\.[0-9]*" | sort -rV | head -n 1)

if [ -z "$GKE_K8S_VERSION" ]; then
    echo "Error: No GKE version found for $K8S_VERSION in RAPID channel." >&2
    exit 1
fi

gcloud container clusters create "$MY_PREFIX-$MY_CLUSTER-$(date +%s)" \
  --zone "$MY_ZONE" \
  --num-nodes 1 \
  --machine-type "$MY_MACHINE_TYPE" \
  --release-channel=rapid \
  --cluster-version "$GKE_K8S_VERSION" \
  --no-enable-basic-auth \
  --addons=GcePersistentDiskCsiDriver,BackupRestore \
  --enable-autoscaling --min-nodes 1 --max-nodes 3

echo
./postgresql-deploy.sh

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo
echo "-------Total time to build a GKE cluster with PostgreSQL is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"