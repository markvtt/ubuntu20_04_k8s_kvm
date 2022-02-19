
echo -e "192.168.223.143 k8smaster k8smaster.home.lab prime.home.lab" | sudo tee -a /etc/hosts
echo -e "192.168.223.144 k8sworker1 k8sworker1.home.lab" | sudo tee -a /etc/hosts
echo -e "192.168.223.145 k8sworker2 k8sworker2.home.lab" | sudo tee -a /etc/hosts
echo -e "192.168.223.146 k8sworker3 k8sworker1.home.lab" | sudo tee -a /etc/hosts