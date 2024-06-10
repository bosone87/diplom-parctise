#!/bin/bash

set -e
ansible-playbook -i kubespray/inventory/mycluster/hosts.ini --become --become-user=root kubespray/cluster.yml -vv
mkdir -p ~/.kube
cd terraform
MASTER_LOCAL_IP="127.0.0.1"
MASTER_1_PUBLIC_IP=$(terraform output -json instance_group_masters_public_ips | jq -j ".[0]")
scp root@$MASTER_1_PUBLIC_IP:/etc/kubernetes/admin.conf ~/.kube/config
sed -i -- "s/$MASTER_LOCAL_IP/$MASTER_1_PUBLIC_IP/g" ~/.kube/config

kubectl label node ingress-1 node-role.kubernetes.io/ingress=true
kubectl label node ingress-2 node-role.kubernetes.io/ingress=true
kubectl label node worker-1 node-role.kubernetes.io/worker=true
kubectl label node worker-2 node-role.kubernetes.io/worker=true
kubectl taint nodes ingress-1 node-role.kubernetes.io/ingress=true:NoSchedule
kubectl taint nodes ingress-2 node-role.kubernetes.io/ingress=true:NoSchedule