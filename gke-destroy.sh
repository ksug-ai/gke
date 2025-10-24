set -e

starttime=$(date +%s)
. ./setenv.sh
echo '-------Deleting the GKE Cluster (typically in few mins)'
TEMP_PREFIX=$(whoami | sed -e 's/[_.]//g' | tr '[:upper:]' '[:lower:]')
FIRST3=$(echo -n "$TEMP_PREFIX" | head -c3)
LAST3=$(echo -n "$TEMP_PREFIX" | tail -c3)
MY_PREFIX="$FIRST3$LAST3"

CLUSTER_FILTER="name~^$MY_PREFIX-$MY_CLUSTER"
GKE_CLUSTERS=$(gcloud container clusters list --format="value(name)" --filter="$CLUSTER_FILTER")

if [ -n "$GKE_CLUSTERS" ]; then
    echo "Deleting GKE cluster(s): $GKE_CLUSTERS"
    gcloud container clusters delete $GKE_CLUSTERS --zone "$MY_ZONE" --quiet
else
    echo "No clusters found with prefix $MY_PREFIX-$MY_CLUSTER to delete."
fi

echo
echo '-------Deleting PostgreSQL persistent disks'
DISK_NAMES=$(gcloud compute disks list --format="value(name)" --filter="labels.created-by=gke-deploy-script")
if [ -n "$DISK_NAMES" ]; then
    echo "Deleting disks: $DISK_NAMES"
    gcloud compute disks delete $DISK_NAMES --zone="$MY_ZONE" --quiet
else
    echo "No PostgreSQL disks found to delete."
fi

echo
echo '-------Deleting the bucket'
BUCKET_NAME="$MY_PREFIX-$MY_BUCKET"
if gsutil ls "gs://$BUCKET_NAME" >/dev/null 2>&1; then
    echo "Deleting bucket gs://$BUCKET_NAME"
    gsutil -m rm -r "gs://$BUCKET_NAME"
fi

echo
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"