cat <<'EOF' > nat223.xml
<network>
  <name>nat223</name>
  <forward mode='nat' dev='wlp4s0'/>
  <bridge name='virbr223' stp='on' delay='2'/>
  <dns>
    <host ip='192.168.223.143'>
      <hostname>k8smaster</hostname>
      <hostname>k8smaster.home.lab</hostname>
      <hostname>prime.home.lab</hostname>
    </host>
    <host ip='192.168.223.144'>
      <hostname>k8sworker1</hostname>
      <hostname>k8sworker1.home.lab</hostname>
    </host>
    <host ip='192.168.223.145'>
      <hostname>k8sworker2</hostname>
      <hostname>k8sworker2.home.lab</hostname>
    </host>
    <host ip='192.168.223.146'>
      <hostname>k8sworker3</hostname>
      <hostname>k8sworker3.home.lab</hostname>
    </host>
  </dns>
  <ip address='192.168.223.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.223.141' end='192.168.223.254'/>
      <host mac='52:54:00:b0:59:5a' name='k8smaster' ip='192.168.223.143'/>
      <host mac='52:54:00:b0:59:5b' name='k8sworker1' ip='192.168.223.144'/>
      <host mac='52:54:00:b0:59:5c' name='k8sworker2' ip='192.168.223.145'/>
      <host mac='52:54:00:b0:59:5d' name='k8sworker3' ip='192.168.223.146'/>
    </dhcp>
  </ip>
</network>
EOF

virsh net-define nat223.xml
virsh net-start nat223
virsh net-autostart nat223

virsh net-list --all

ip a | grep 223

sudo iptables -L FORWARD -nv --line-number | grep virbr223

sudo iptables -t nat -L -n -v --line-number | grep 223
