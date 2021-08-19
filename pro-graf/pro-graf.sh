#!/bin/bash
helm repo add stable https://charts.helm.sh/stable
helm repo update
sudo helm install prometheus-operator stable/prometheus-operator --namespace monitor --set grafana.service.type=LoadBalancer
sudo kubectl apply -f ingress.yaml -n monitor
sudo kubectl get svc -n monitor | grep prometheus-operator-grafana
