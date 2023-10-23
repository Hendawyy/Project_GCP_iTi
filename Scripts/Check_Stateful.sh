#!/bin/bash

# Define the number of times to execute the curl command
num_curls=10

# Loop to execute the curl commands
for ((i=1; i<=num_curls; i++)); do
    curl $1
    echo
done

kubectl delete pods mongodb-0 mongodb-1 mongodb-2 -n mongo

sleep 30

kubectl get pods -n mongo -owide

# Loop to execute the curl commands again
for ((i=1; i<=num_curls; i++)); do
    curl $1
    echo
done