echo -e "Ensure value not 0"
egrep -c '(vmx|svm)' /proc/cpuinfo

echo -e "Verify network devices (script is using wlp4s0) "
nmcli con show

