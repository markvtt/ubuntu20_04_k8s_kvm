#!/bin/bash

sudo mkdir -p /root/.kube 
sudo cp /tmp/config /root/.kube
sudo mkdir -p /home/mark/.kube 
sudo cp /tmp/config /home/mark/.kube
sudo chown -R mark:mark /home/mark/.kube

chmod +x /tmp/join.sh
/tmp/join.sh
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
