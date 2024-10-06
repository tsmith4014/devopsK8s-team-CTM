#!/bin/bash

minikube start

sleep 10

kubectl apply -f k8s/namespace.yml

sleep 3

kubectl create configmap db-backup-configmap --from-file=db_backup.sql -n shredder

sleep 3

kubectl apply -f k8s/. -n shredder

sleep 45

minikube service nginx-service -n shredder