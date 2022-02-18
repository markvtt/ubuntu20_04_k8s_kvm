#! /bin/bash
declare -a VMS=("k8smaster" "k8sworker1" "k8sworker2" "k8sworker3")

for VM_NAME in "${VMS[@]}"; do
    echo -e "VM_NAME=$VM_NAME"
    virsh shutdown $VM_NAME
    virsh destroy $VM_NAME
    virsh undefine $VM_NAME
    rm -Rf /var/lib/libvirt/images/${VM_NAME}
done