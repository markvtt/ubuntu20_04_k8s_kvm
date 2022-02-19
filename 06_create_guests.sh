#! /bin/bash
declare -a VMS=("k8smaster" "k8sworker1" "k8sworker2" "k8sworker3")
declare -a MACS=("52:54:00:b0:59:5a" "52:54:00:b0:59:5b" "52:54:00:b0:59:5c" "52:54:00:b0:59:5d")

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
    
    # cloud-config doco: https://cloudinit.readthedocs.io/en/latest/topics/examples.html

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

ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB2rybcSQW1wlYAeLex8UIFOmK8cSmiCdHeoZrUOkXKJEB/WNvaRDeylqBgbEA/3DcqKMCtTnmxB92KCuSZV1nD93+fD5aCELXNPq7Umt2K/yL0MKGFyhUWPZ2FagHW4TJnDtq/2cW6RB4gaWaWIpyjup4twm+88aBlX3C1fV7bzrQoVHj7R26+NViLhLAm6RWYPzwFqTb4RWQ08gZS2idT34I5NkyLaORaWiCBwJPxU9WxfMBNnP/Cr9Opsq3oVmgdY5rQ/OP47kypHY73UxqxySEmzNV7B/IRc46tiKBYO6tfGabO2OYUv8Sw3YbKIfDSbTUuUv84Kk+Gho9NgWUg5ruobvO6IXeNLi4fLE+wxlb+keDj4TuBOO3AKihA4oEyCPYAjhXBeDDtT1tjje/yw7jZSfghhsj8vlJ6O/msEcB9MILS1Aao4/O+39AYuEdHr0OqvnpjtgGF6EvD5fELjty6YbPgLuoibv7KW+ufuYWow9dM9PvK/orB3JavZ5NqXue86BCDXR+LnpliXWZkTkyPe39V3rWdNqNbklfnqC129q5Jpysp5fn4mMs2PIBBpzYYWUatwOEHKlHQA/y4NrF0beH7Kvk7aN4W+3lekSCPPrf87l7V/9pdTj3Qem2Josc8DSCLa6i6kb/OHJtFHcbnEmIWa5XKiWGzAK4dQ== mark@ephemeral

runcmd:
 - cd /root && git clone https://github.com/markvtt/ubuntu20_04_k8s_kvm.git
 
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
    --mac="$MACADDR" \
    --import \
    --noautoconsole

done
