#### Follow [@YongkangHe](https://twitter.com/yongkanghe) on Twitter, Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

I just want to build a GKE Cluster to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. It is challenging to create a GKE cluster from Google Cloud if you are not familiar to it. After the GKE Cluster is up running, we still need to install a sample DB etc.. The whole process is not that simple.

This script based automation allows you to build a ready-to-use GKE cluster with PostgreSQL in about 5 minutes. For simplicity and cost optimization, the GKE cluster will have only one worker node and be built in the default vpc using the default subnet. This is bash shell based scripts which has been tested on Cloud Shell. Linux or MacOS terminal has not been tested though it might work as well. 

# Sign up a GCP Trial Account
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/ziKH3a8ISQM/0.jpg)](https://www.youtube.com/watch?v=ziKH3a8ISQM)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Here're the prerequisities. 
1. Go to open Google Cloud Shell
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/ksug-ai/gke.git;cd gke
````
3. Enable GKE API if not enabled
````
./createsa.sh
````
4. Optionally, you can customize the clustername, machine-type, zone, region
````
vi setenv.sh
````

# GKE Cluster Automation 

1. To deploy a GKE cluster
````
./gke-deploy.sh
````

2. To destroy the GKE cluster after testing
````
./gke-destroy.sh
````

# GKE Automation video
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/3rpgIMDW8F0/0.jpg)](https://www.youtube.com/watch?v=3rpgIMDW8F0)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Secure GKE Containers via KubeArmor 
Install KubeArmor via Automation
````
./karmor-deploy.sh
````
Uninstall KubeArmor via Automation
````
./karmor-destroy.sh
````

# Secure GKE Containers via Falco 
Install Falco via Automation
````
./falco-deploy.sh
````
Uninstall Falco via Automation
````
./falco-destroy.sh
````

# Velero for GKE Automation 

1. 1 min to enable GKE Backup via Velero
````
./velero-deploy.sh
````

2. To clean up Velero for GKE
````
./velero-destroy.sh
````

# 1 min to enable Containers Backup via Velero
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/9E4I1BaygUM/0.jpg)](https://www.youtube.com/watch?v=9E4I1BaygUM)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# 30 mins to enable Backup for GKE
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/H0UNvG_CJwk/0.jpg)](https://www.youtube.com/watch?v=H0UNvG_CJwk)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Build a GKE cluster via Web UI
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YwfPqR5phLM/0.jpg)](https://www.youtube.com/watch?v=YwfPqR5phLM)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Contributors
#### Follow [Yongkang He](https://linktr.ee/ksug.ai) on LinkedIn
#### Join [KSUG.AI Discord](https://discord.com/invite/Rp9WzYyKua)
#### Join [KSUG.AI Discussions](https://www.linkedin.com/groups/13983251) LinkedIn Group
#### Join [KSUG.AI Telegram Chat](https://t.me/+QsBjgoId34EzN2I1)
#### Join [KSUG.AI Meetup](https://meetup.com/pro/yongkang) User Group


