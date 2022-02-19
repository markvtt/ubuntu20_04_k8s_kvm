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
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbg44NuIfQsuaoz/CoCDhcRqWy81yLVPa95LkpyQNTkwur8FMFvOnUS6OhnE/Qc/rUz/4UATzRoKs7XTjn1xfILuaXjQKXga2iZIqt/sfF5Ojx8fZT8hloqTpZ6Pm+RWhkh6MXwo/dvG+bmiFR8/3Kg20jHc5Fa7G/Oykxohn9nCMGBQAkj1w+7NaCwv4EnFsX6wAz4HEXlUk/NHkxsReWcM6rZuE3SpELwIg2x8vT1o26vN4nmokCHeO4wVeUsVsUG1O1IaQhsw7/igsyvMaH9rbS9cLlIGSDbs9cV7I03f94PEZ1aFc6pPLL9hgHFtijjhcnPYEDkUpoan/yBamInuQQfw2qwq9RoLeUDaarxdrfvFJGx4sR26mxoDUIjtR72eVIXYackHKwLnWs/wajz3Ftt31/qTYt9uSY3ONSAUiYvFoVsF8hoDAYdxfIrL8nXNfqbfqUUouctuL4AMKVcbJKf1PCR9ljmaokaNSDyadfubKobd7fyAkHCDQaDhxesRh4ONJDkWfpVyz7t8qtdzTWPIWl8ls5C/3plV/kMGoz87R648n00knGH/WRyNn4J7Ztox8zpvWfrgaUnMqn1SK0tfO8TyPuHo8E3vOcoGB5UGtfwdQSVBuZ6ixMSGRWwf4JYJZyetAWkpUj7z5+cpqUYNDWjMZQlg3nQHfHGQ== mark@ubuntu.ephemeral

runcmd:
 - cd /root && git clone https://github.com/markvtt/ubuntu20_04_k8s_kvm.git
 - cd /root/ubuntu20_04_k8s_kvm && ./09_update_rsa_keys.sh
 
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
