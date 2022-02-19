#! /bin/bash
declare -a VMS=("k8smaster" "k8sworker1" "k8sworker2" "k8sworker3")

for VM_NAME in "${VMS[@]}"; do
  echo -e "VM_NAME=$VM_NAME"
  qemu-img create -f raw /var/lib/libvirt/images/$VM_NAME/vm-disk2-20G 20G
  virsh attach-disk $VM_NAME /var/lib/libvirt/images/$VM_NAME/vm-disk2-20G vdb --cache none
done
