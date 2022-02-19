
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh

cp ./id_rsa /root/.ssh
sudo chmod 600 /root/.ssh/id_rsa

cp ./id_rsa.pub /root/.ssh
sudo chmod 644 /root/.ssh/id_rsa.pub

sudo chown -R root:root /root/.ssh

sudo mkdir -p /home/mark/.ssh
sudo chmod 700 /home/mark/.ssh

cp ./id_rsa /home/mark/.ssh
sudo chmod 600 /home/mark/.ssh/id_rsa

cp ./id_rsa.pub /home/mark/.ssh
sudo chmod 644 /home/mark/.ssh/id_rsa.pub

sudo chown -R mark:mark /home/mark/.ssh

sudo ls -l /root/.ssh
sudo ls -l /home/mark/.ssh
