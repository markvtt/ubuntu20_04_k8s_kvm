#!/bin/bash

echo -e "Ensure kvm exists"
kvm-ok

echo -e "Ensure value is 1"
cat /proc/sys/net/ipv4/ip_forward

