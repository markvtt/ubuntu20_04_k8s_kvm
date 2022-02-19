# ubuntu20_04_k8s_kvm

git clone https://github.com/markvtt/ubuntu20_04_k8s_kvm.git

## install desktop
sudo apt-get install --no-install-recommends ubuntu-desktop
sudo apt install firefox

## install anydesk
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list

apt update
apt install anydesk
