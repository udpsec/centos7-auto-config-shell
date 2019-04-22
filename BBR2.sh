#!/usr/bin/env bash
# File Title: BBR2.sh
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年09月30日 星期六 18时04分16秒
# Version: 1.0

echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
sysctl -p
echo "------------------------------------------"
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr
