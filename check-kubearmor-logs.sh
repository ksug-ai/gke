#!/bin/bash

# Option 1: Check KubeArmor logs with JSON output (shows recent alerts)
echo "=== Recent KubeArmor Alerts (JSON) ==="
karmor logs --json -n yong-nginx --logFilter=policy &
sleep 5
pkill -f "karmor logs"

# Option 2: Check KubeArmor relay pod logs directly
echo -e "\n=== KubeArmor Relay Pod Logs ==="
kubectl logs -n yong-kubearmor -l kubearmor-app=kubearmor-relay --tail=50

# Option 3: Check KubeArmor host pod logs
echo -e "\n=== KubeArmor Host Pod Logs ==="
kubectl logs -n yong-kubearmor -l kubearmor-app=kubearmor --tail=50 --all-containers

# Option 4: Watch alerts in real-time (Ctrl+C to stop)
echo -e "\n=== Watching Real-time Alerts (Press Ctrl+C to stop) ==="
karmor logs -n yong-nginx --logFilter=policy
