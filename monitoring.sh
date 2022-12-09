#!/bin/bash

LVM_use=$(lsblk | grep -c " lvm   " | awk '{if ($1 != 0) {print "yes"}else {print "no"}}')

arc=$(uname -a)
PCU=$(lscpu | grep -m 1 "CPU(s)" | awk '{print($2)}')
VCPU=$(cat /proc/cpuinfo | grep -c "^processor")
UMEM=$(free -m | grep "Mem" | awk '{ print($2) }')
VMEM=$(free -m | grep "Mem" | awk '{ print($3) }')
PMEM=$(free -m | grep "Mem" | awk '{ printf("%.2f%%", $3/$2 * 100) }')
DUS=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
DTO=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{to+=$2} END {print(to)}')
TDSI=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{us += $3} {fs+= $2} END {printf("%d%%"), us/fs * 100}')
CPL=$(top -n1 | grep "^%Cpu(s):" | awk '{printf("%.1f%%", $2 + $4)}')
LB=$(who -b | awk '$1 == "system" {print $3 " " $4}')
CTCP=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')
ULOGS=$(users | wc -w)
IP=$(hostname -I)
MACA=$(ip link show | awk '$1 == "link/ether" {print $2}')
CMDS=$(journalctl -q | grep -c ']: pam_unix(sudo:session): session closed for user')
wall "	#Architecture: $arc
	#CPU physical: $PCU
	#vCPU: $VCPU
	#Memory Usage: $VMEM/${UMEM}MB ($PMEM)
	#Disk Usage: $DUS/${DTO}Gb ($TDSI)
	#CPU load: $CPL
	#Last boot: $LB
	#LVM use: $LVM_use
	#Connexions TCP: $CTCP ESTABLISHED
	#User log: $ULOGS
	#Network: IP $IP ($MACA)
	#Sudo: $CMDS cmd"