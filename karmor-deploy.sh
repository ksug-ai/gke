echo '-------Installing KubeArmor on GKE Cluster (typically in ~2 mins)'
starttime=$(date +%s)

# Add helm chart repo
helm repo add kubearmor https://kubearmor.github.io/charts 2>/dev/null || true
if [ ! -f ~/.cache/helm/repository/kubearmor-index.yaml ] || [ $(find ~/.cache/helm/repository/kubearmor-index.yaml -mtime +7 2>/dev/null | wc -l) -gt 0 ]; then
  helm repo update kubearmor
fi

# Install KubeArmor
helm upgrade --install kubearmor-operator kubearmor/kubearmor-operator -n yong-kubearmor --create-namespace 
kubectl apply -f ./kubearmor-sample-config.yaml

echo "-------Deploying a test nginx app for the original demo"
kubectl create namespace yong-nginx
kubectl create deployment nginx4yong1 --image=nginx -n yong-nginx

# Deploy a vulnerable LLM test app for the new AI security demo
echo "-------Deploying a vulnerable LLM application for demonstration"
kubectl apply -f ./llm-app-deploy.yaml

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "" | awk '{print $1}'
echo "-------Total time to install KubeArmor with karmor CLI is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'