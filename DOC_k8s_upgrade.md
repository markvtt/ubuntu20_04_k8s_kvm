https://kubernetes.io/docs
Search docs: Upgrading kubeadm clusters

https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/


# Master
apt update
apt-cache madison kubeadm

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.21.10-00 && \
apt-mark hold kubeadm

kubeadm version


sudo kubeadm upgrade apply v1.21.10

kubectl drain k8smaster --ignore-daemonsets --delete-emptydir-data

apt-mark unhold kubelet kubectl && \
    apt-get update && apt-get install -y kubelet=1.21.10-00 kubectl=1.21.10-00 && \
    apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubelet --version
kubectl version

kubectl uncordon k8smaster

# Worker

NODE_NAME=k8sworker1
NODE_NAME=k8sworker2

apt update

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.21.10-00 && \
apt-mark hold kubeadm

sudo kubeadm upgrade node

kubectl drain $NODE_NAME --ignore-daemonsets --delete-emptydir-data

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.21.10-00 kubectl=1.21.10-00 && \
apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl uncordon $NODE_NAME

