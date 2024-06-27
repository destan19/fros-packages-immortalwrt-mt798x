#!/bin/sh /etc/rc.common
. /usr/share/libubox/jshn.sh
. /lib/functions.sh

START=80
STOP=20
wan_ifname=""
flush_qos_rule()
{
	iptables -t mangle  -F POSTROUTING
	tc qdisc del dev br-lan root
	tc qdisc del dev $wan_ifname root
}

init_root()
{
	tc qdisc add dev br-lan root handle 1:0 htb default 999
	tc class add dev br-lan parent 1:0 classid 1:999 htb rate 1000Mbit ceil 1000Mbit
	tc qdisc add dev $wan_ifname root handle 1:0 htb default 999
	tc class add dev $wan_ifname parent 1:0 classid 1:999 htb rate 1000Mbit ceil 1000Mbit
}

add_qos_rule()
{
	local id=$1
	local iprange=$2
	local up_rate=$3
	local down_rate=$4
	echo "-----------------------iprange = $iprange"
	iptables -t mangle -A POSTROUTING -m  iprange --dst-range $iprange  -j MARK --or-mark $id
	iptables -t mangle -A POSTROUTING -m  iprange --src-range $iprange  -j MARK --or-mark $id
	local up_rate_kb=`expr $up_rate \* 8`
	local down_rate_kb=`expr $down_rate \* 8`
	echo "down rate $down_rate_kb kbps, up rate $up_rate_kb kbps"
	#download tc rule
	tc class add dev br-lan parent 1:0 classid 1:$id htb rate ${down_rate_kb}Kbit ceil ${down_rate_kb}Kbit
	tc filter add dev br-lan parent 1:0 prio 10 handle $id/0xff fw classid 1:$id
	#upload tc rule
	tc class add dev $wan_ifname parent 1:0 classid 1:$id htb rate ${up_rate_kb}Kbit ceil ${up_rate_kb}Kbit
	tc filter add dev $wan_ifname parent 1:0 prio 10 handle $id/0xff fw classid 1:$id
}
count=1
qos_rule_handle()
{
	echo "handle rule"
	local ip_range
	local up_rate
	local down_rate
	local enable
	local cfg="$1"     
	config_get enable "$cfg" 'enable' '0'
	if [ x"1" != x"$enable" ];then
		return
	fi
	config_get up_rate   "$cfg" 'up_rate' 1024000
	config_get down_rate "$cfg" 'down_rate' 1024000
	config_get ip_range "$cfg" 'ip_range' '0.0.0.0'
	echo "add ip_range = $ip_range"
	
	list=`echo $ip_range  |awk -F,  '{for (i = 1; i <= NF; i++) printf $i " "}'`
	echo $list

	for ip in $list
	do
		echo "ip = $ip"
		echo $ip | grep - >/dev/null
		if [ $? -eq 0 ];then
			add_qos_rule $count $ip  $up_rate $down_rate
		else
			add_qos_rule $count $ip-$ip  $up_rate $down_rate
		fi
			echo "result=$?"
	done
	#echo "id = $count, up = $up_rate, down = $down_rate, $start_ip-$end_ip"
	#add_qos_rule $count $start_ip $end_ip $up_rate $down_rate
	count=`expr $count + 1`
}
init_wan_ifname()
{
	wan_ifname=`uci get network.wan.ifname`
	echo "ifname = $wan_ifname"
}

start()
{
	local enable=`uci get ip_qos.global.enable`
	if [ x"1" != x"$enable" ];then
		echo "qos is disabled"
		return
	fi
	init_wan_ifname
	init_root
	config_load ip_qos
	config_foreach qos_rule_handle rule	
	echo "start qos...ok"
}
stop()
{
	init_wan_ifname
	flush_qos_rule
	echo "stop qos...ok"
}

