#! /bin/bash
curl --insecure --user mark:mark1 -T /vagrant/configs/config sftp://192.168.223.144/tmp/config
curl --insecure --user mark:mark1 -T /vagrant/configs/join.sh sftp://192.168.223.144/tmp/join.sh
curl --insecure --user mark:mark1 -T /vagrant/configs/config sftp://192.168.223.145/tmp/config
curl --insecure --user mark:mark1 -T /vagrant/configs/join.sh sftp://192.168.223.145/tmp/join.sh
curl --insecure --user mark:mark1 -T /vagrant/configs/config sftp://192.168.223.146/tmp/config
curl --insecure --user mark:mark1 -T /vagrant/configs/join.sh sftp://192.168.223.146/tmp/join.sh
