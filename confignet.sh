#!/sbin/busybox sh
echo "config net..."

#cp /system/binary/root/* /root/

insmod /system/binary/rtloader.ko

sleep 3

insmod /system/binary/vbus.ko

sleep 1

insmod /system/binary/vnet0.ko

ifconfig vnet0 192.168.5.2

ip neighbor add 192.168.5.1 lladdr 05:89:89:89:89:89  dev vnet0

#cp /system/busybox-armv7l /sbin/

#chmod 777 /sbin/busybox-armv7l

busybox-smp telnetd -l /system/bin/sh
