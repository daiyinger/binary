#! /bin/sh

# 提取USB转RJ45网口ra0的IP地址:
OUT_IP=`ifconfig ra0 | sed -n 's/inet addr:\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)[[:space:]]*/ \1 /p'|awk -F ' ' '{print $1}'`

# 提取Adnroid 侧vnet0 ip地址
VNET0_IP=`ifconfig vnet0 | sed -n 's/inet addr:\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)[[:space:]]*/ \1 /p'|awk -F ' ' '{print $1}'`

# 提取LINUX 侧VNET0 ip地址
VNET0_IP_LINUX='192.168.5.1' #`ifconfig vnet0|sed -n 's/P-t-P:\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)/ \1 /p'|awk -F ' ' '{print $3}'`

echo "OUT_IP:$OUT_IP."
echo "VNET0_IP:$VNET0_IP."
echo "VNET0_IP_LINUX:$VNET0_IP_LINUX."

# 允许内核转发
echo 1 > /proc/sys/net/ipv4/ip_forward
#关闭防火墙
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

#配置NAT
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

#针对输出包(即从linux侧发往大网的报文)，如果源IP是10.10.10.0/24网段，则使用NAT表转发到ra0接口外发.
iptables -t nat -A POSTROUTING -s $VNET0_IP_LINUX/24 -j SNAT --to $OUT_IP

#针对输入包(即从大网发送到android侧的报文),如果目的IP是192.168.100.242网口，则使用NAT同时转发到linux侧.
iptables -t nat -A PREROUTING -d $OUT_IP -j DNAT --to $VNET0_IP_LINUX
