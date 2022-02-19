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

ssh_keys:
  rsa_private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    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
    -----END OPENSSH PRIVATE KEY-----  

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
