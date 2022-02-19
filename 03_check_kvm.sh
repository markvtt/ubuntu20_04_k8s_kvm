echo -e "Ensure:"
echo -e "INFO: /dev/kvm exists"
echo -e "KVM acceleration can be used"
kvm-ok

echo -e "Ensure value is 1"
cat /proc/sys/net/ipv4/ip_forward
