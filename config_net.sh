#! /bin/sh
echo "7       4       1       7" > /proc/sys/kernel/printk
cd /system/binary
cp root/* /root/
insmod rtloader.ko
sleep 5
insmod vbus.ko
sleep 1
insmod vnet0.ko
ifconfig vnet0 192.168.5.2
ip neighbor add 192.168.5.1 lladdr 05:89:89:89:89:89  dev vnet0
#cp /system/busybox-armv7l /sbin/
#chmod 777 /sbin/busybox-armv7l
busybox-smp telnetd -l /system/bin/sh

