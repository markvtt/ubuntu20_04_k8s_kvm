#!/bin/bash

# for latest use:
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO https://dl.k8s.io/release/v1.20.6/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl_v1.20.6
sudo unlink /usr/local/bin/kubectl
sudo ln -s /usr/local/bin/kubectl_v1.20.6 /usr/local/bin/kubectl
kubectl version --client


