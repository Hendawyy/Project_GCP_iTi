#!/bin/bash

# Step 1: Connect to the cluster
gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project hendawy-iti-gcp --internal-ip

# Step 2: Connect to the cluster from the remote local private instance using IAP
gcloud compute ssh private-vm-instance \
    --tunnel-through-iap \
    --project=hendawy-iti-gcp \
    --zone=us-east1-b \
    --ssh-flag="-4 -L8888:localhost:8888 -N -q -f" 2>/dev/null

# Step 3: Specify the proxy
export HTTPS_PROXY=localhost:8888

# Show GKE Nodes
kubectl get nodes

# Step 4 Apply the K8s files to the GKE

# Sepcify The Directory
cd ~/Documents/Projects/GCP_Project/Project_GCP_iTi

# Apply The files for the MongoDB (Backend Configuration)
kubectl apply -f Kubernetes/Mongo/

# Use the sleep command to pause for 45 seconds untill the db pod is up & running
sleep 30

# Show Created MongoDB Pods
kubectl get pods -n mongo -owide

# Apply The files for the Nodejs App (Frontend Configuration)
kubectl apply -f Kubernetes/App/


# Show Created NodeJs Pods
kubectl get pods -n node

# Use the sleep command to pause for 10 more seconds incase not all the pods are running
sleep 10

# Show Created MongoDB Pods
kubectl get pods -n mongo -owide