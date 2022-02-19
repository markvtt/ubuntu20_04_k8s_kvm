sudo mkdir /var/lib/libvirt/images/templates
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

sudo mv -i focal-server-cloudimg-amd64.img \
  /var/lib/libvirt/images/templates/ubuntu-20-server.qcow2

echo -c "Check if this image exists"
ls -l  /var/lib/libvirt/images/templates/ubuntu-20-server.qcow2
