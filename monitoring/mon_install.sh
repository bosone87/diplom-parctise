#!/bin/bash
set -e
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo update 
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --create-namespace -n monitoring -f grafana.yml
kubectl apply -f grafana-svc.yml
sleep 1m