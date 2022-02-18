#! /bin/bash
declare -a VMS=("k8smaster" "k8sworker1" "k8sworker2" "k8sworker3")
declare -a MACS=("52:54:00:b0:59:5a" "52:54:00:b0:59:5b" "52:54:00:b0:59:5c" "52:54:00:b0:59:5c")

USERNAME="mark"
PASSWORD="mark1"

for (( i=0; i<4; i++ )); do

    VM_NAME=${VMS[$i]}
    MACADDR=${MACS[$i]}

    echo -e "VM_NAME=$VM_NAME"
    echo -e "MACADDR=$MACADDR"

    sudo mkdir /var/lib/libvirt/images/$VM_NAME \
    && sudo qemu-img convert \
    -f qcow2 \
    -O qcow2 \
    /var/lib/libvirt/images/templates/ubuntu-20-server.qcow2 \
    /var/lib/libvirt/images/$VM_NAME/root-disk.qcow2

    sudo qemu-img resize \
    /var/lib/libvirt/images/$VM_NAME/root-disk.qcow2 \
    20G

    sudo echo "#cloud-config
    system_info:
    default_user:
        name: $USERNAME
        home: /home/$USERNAME

    password: $PASSWORD
    chpasswd: { expire: False }
    hostname: $VM_NAME

    # configure sshd to allow users logging in using password 
    # rather than just keys
    ssh_pwauth: True
    " | sudo tee /var/lib/libvirt/images/$VM_NAME/cloud-init.cfg

    echo -e "Using cloud-init.cfg"
    cat /var/lib/libvirt/images/$VM_NAME/cloud-init.cfg

    sudo cloud-localds \
    /var/lib/libvirt/images/$VM_NAME/cloud-init.iso \
    /var/lib/libvirt/images/$VM_NAME/cloud-init.cfg

    sudo virt-install \
    --name $VM_NAME \
    --memory 2048 \
    --vcpus 1 \
    --disk /var/lib/libvirt/images/$VM_NAME/root-disk.qcow2,device=disk,bus=virtio \
    --disk /var/lib/libvirt/images/$VM_NAME/cloud-init.iso,device=cdrom \
    --os-type linux \
    --os-variant ubuntu20.04 \
    --virt-type kvm \
    --graphics none \
    --network network=nat223,model=virtio \
    --mac=$MACADDR \
    --import \
    --noautoconsole

done