#!/bin/bash

sudo apt-get install -qy qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager ovmf libosinfo-bin cloud-image-utils

sudo apt-get install -qy net-tools


sudo service libvirtd status
sudo systemctl enable --now libvirtd
