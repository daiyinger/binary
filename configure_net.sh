#! /bin/sh
insmod vbus.ko
sleep 1
insmod vnet0.ko
ifconfig vnet0 192.168.5.2
arp -s 192.168.5.1 05:89:89:89:89:89
route add -net 192.168.5.0/24 gw 192.168.5.2 vnet0
