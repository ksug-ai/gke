#!/bin/bash

echo "------- DVWA Access Guide -------"
echo

# Get the pod name
export POD_NAME=$(kubectl get pods -n yong-llm-app -l app=llm-app -o jsonpath='{.items[0].metadata.name}')
echo "DVWA Pod: $POD_NAME"
echo

# Option 1: Port Forward
echo "Option 1: Access via Port Forward"
echo "Run this command in a separate terminal:"
echo "  kubectl port-forward -n yong-llm-app $POD_NAME 8080:80"
echo "Then open: http://localhost:8080"
echo

# Option 2: LoadBalancer IP
echo "Option 2: Access via LoadBalancer (if available)"
EXTERNAL_IP=$(kubectl get svc llm-app-service -n yong-llm-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -n "$EXTERNAL_IP" ]; then
  echo "External IP: http://$EXTERNAL_IP"
else
  echo "LoadBalancer IP not yet assigned. Wait a moment and check with:"
  echo "  kubectl get svc llm-app-service -n yong-llm-app"
fi
echo

echo "------- DVWA Login Credentials -------"
echo "Username: admin"
echo "Password: password"
echo

echo "------- First Time Setup -------"
echo "1. After login, click 'Create / Reset Database' button"
echo "2. Login again with admin/password"
echo "3. Set Security Level to 'Low' for testing"
echo "4. Navigate to 'Command Injection' for demo"
echo
