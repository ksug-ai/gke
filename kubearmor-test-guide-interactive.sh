#!/bin/bash

# Get pod name
export POD=$(kubectl get pod -l app=nginx4yong1 -o name -n yong-nginx)
echo "Using pod: $POD"
echo

# KubeArmor Test Case -1: Deny execution of apt / apt-get
echo "========================================================"
echo "KubeArmor Test Case -1: Block Package Management Tools"
echo "========================================================"
echo
echo "Scenario: Prevent attackers from downloading malicious tools"
echo "using package managers like apt/apt-get."
echo

read -p "Press [Enter] to start Test Case 1..."
echo

echo "--- Step 1: Try to run apt (BEFORE policy) ---"
echo "Command: kubectl exec -it $POD -n yong-nginx -- bash -c 'apt update'"
echo
kubectl exec -it $POD -n yong-nginx -- bash -c "apt update" 2>&1 | head -10
echo
echo "✓ apt command executed successfully (no policy yet)"
echo

read -p "Press [Enter] to apply KubeArmor policy..."
echo

echo "--- Step 2: Apply policy to block apt/apt-get ---"
echo "Command: kubectl apply -f ./block-pkg-mgmt-tools-exec.yaml"
echo
kubectl apply -f ./block-pkg-mgmt-tools-exec.yaml
echo
echo "Waiting 5 seconds for policy to take effect..."
sleep 5
echo

read -p "Press [Enter] to test if apt is blocked..."
echo

echo "--- Step 3: Start monitoring KubeArmor logs ---"
karmor logs -n yong-nginx --logFilter=policy &
LOG_PID=$!
sleep 2
echo

echo "--- Step 4: Try to run apt again (AFTER policy) ---"
echo "Command: kubectl exec -it $POD -n yong-nginx -- bash -c 'apt update'"
echo
kubectl exec -it $POD -n yong-nginx -- bash -c "apt update" 2>&1
echo
echo "✗ apt command BLOCKED by KubeArmor!"
echo
sleep 3
kill $LOG_PID 2>/dev/null
echo

read -p "Press [Enter] to continue to next test case..."
echo
echo

echo "========================================================"
echo "KubeArmor Test Case -2: Block Service Account Token Access"
echo "========================================================"
echo
echo "Scenario: Prevent attackers from stealing service account"
echo "tokens for lateral movement."
echo

read -p "Press [Enter] to start Test Case 2..."
echo

echo "--- Step 1: Try to read service account token (BEFORE policy) ---"
echo "Command: cat /run/secrets/kubernetes.io/serviceaccount/token"
echo
kubectl exec -it $POD -n yong-nginx -- bash -c "cat /run/secrets/kubernetes.io/serviceaccount/token" 2>&1 | head -3
echo
echo "✓ Token accessible (no policy yet)"
echo

read -p "Press [Enter] to apply KubeArmor policy..."
echo

echo "--- Step 2: Apply policy to block service account token access ---"
echo "Command: kubectl apply -f ./block-service-access-token-access.yaml"
echo
kubectl apply -f ./block-service-access-token-access.yaml
echo
echo "Waiting 5 seconds for policy to take effect..."
sleep 5
echo

read -p "Press [Enter] to test if token access is blocked..."
echo

echo "--- Step 3: Try to read service account token (AFTER policy) ---"
echo "Command: cat /run/secrets/kubernetes.io/serviceaccount/token"
echo
kubectl exec -it $POD -n yong-nginx -- bash -c "cat /run/secrets/kubernetes.io/serviceaccount/token" 2>&1
echo
echo "✗ Token access BLOCKED by KubeArmor!"
echo

read -p "Press [Enter] to continue to next test case..."
echo
echo

echo "========================================================"
echo "KubeArmor Test Case -3: Audit File Access"
echo "========================================================"
echo
echo "Scenario: Monitor and audit access to sensitive files"
echo "for compliance purposes."
echo

read -p "Press [Enter] to start Test Case 3..."
echo

echo "--- Step 1: Enable file visibility ---"
echo "Command: kubectl annotate ns yong-nginx kubearmor-visibility='process, file, network' --overwrite"
echo
kubectl annotate ns yong-nginx kubearmor-visibility="process, file, network" --overwrite
echo

read -p "Press [Enter] to apply audit policy..."
echo

echo "--- Step 2: Apply policy to audit /etc/nginx access ---"
echo "Command: kubectl apply -f ./audit-etc-nginx-access.yaml"
echo
kubectl apply -f ./audit-etc-nginx-access.yaml
echo
echo "Waiting 5 seconds for policy to take effect..."
sleep 5
echo

read -p "Press [Enter] to start monitoring and access file..."
echo

echo "--- Step 3: Start monitoring KubeArmor audit logs ---"
echo "Monitoring audit logs for nginx.conf access..."
karmor logs -n yong-nginx --logFilter=policy &
LOG_PID=$!
sleep 2
echo

echo "--- Step 4: Access /etc/nginx/nginx.conf ---"
echo "Command: head /etc/nginx/nginx.conf"
echo
kubectl exec -it $POD -n yong-nginx -- bash -c "head /etc/nginx/nginx.conf"
echo
echo "✓ File accessed (audit event generated)"
echo
sleep 3
kill $LOG_PID 2>/dev/null
echo

read -p "Press [Enter] to continue to next test case..."
echo
echo

echo "========================================================"
echo "KubeArmor Test Case -4: Least Permissive Policy (Allow-list)"
echo "========================================================"
echo
echo "Scenario: Allow only nginx binary to execute, block all"
echo "other commands for maximum security."
echo

read -p "Press [Enter] to start Test Case 4..."
echo

echo "--- Step 1: Apply allow-list policy (only nginx allowed) ---"
echo "Command: kubectl apply -f ./only-allow-nginx-exec.yaml"
echo
kubectl apply -f ./only-allow-nginx-exec.yaml
echo

read -p "Press [Enter] to set security posture to block..."
echo

echo "--- Step 2: Change security posture to block mode ---"
echo "Command: kubectl annotate ns yong-nginx kubearmor-file-posture=block --overwrite"
echo
kubectl annotate ns yong-nginx kubearmor-file-posture=block --overwrite
echo
echo "Waiting 5 seconds for policy to take effect..."
sleep 5
echo

read -p "Press [Enter] to test blocked commands..."
echo

echo "--- Step 3: Try to run various commands (should be blocked) ---"
echo
echo "Command: passwd"
kubectl exec -it $POD -n yong-nginx -- bash -c "passwd" 2>&1
echo "✗ passwd BLOCKED"
echo
echo "Command: ls"
kubectl exec -it $POD -n yong-nginx -- bash -c "ls" 2>&1
echo "✗ ls BLOCKED"
echo
echo "Command: chroot"
kubectl exec -it $POD -n yong-nginx -- bash -c "chroot" 2>&1
echo "✗ chroot BLOCKED"
echo

read -p "Press [Enter] to verify nginx still works..."
echo

echo "--- Step 4: Verify nginx is still accessible ---"
kubectl port-forward $POD -n yong-nginx --address 0.0.0.0 8080:80 &
PF_PID=$!
sleep 2
echo "Testing nginx with curl localhost:8080"
curl -s localhost:8080 | head -5
echo
echo "✓ Nginx still works! Only nginx binary is allowed."
kill $PF_PID 2>/dev/null
echo

read -p "Press [Enter] to finish..."
echo
echo "========================================================"
echo "All test cases completed!"
echo "========================================================"
