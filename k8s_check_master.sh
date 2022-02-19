#! /bin/bash

if [ "$HOSTNAME" = "k8smaster" ]; then
    /root/ubuntu20_04_k8s_kvm/k8s_master1.sh && /root/ubuntu20_04_k8s_kvm/k8s_master2.sh 
fi