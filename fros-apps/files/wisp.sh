#!/bin/sh
. /lib/functions.sh                  
. /usr/share/libubox/jshn.sh   

wifi_driver_type=2
wlog()
{
	echo "$1" >>/tmp/log/wisp.log
}
get_wifi_driver_type_json() {
        local cfg="/etc/product_feature"
        local value
        [ -s "$cfg" ] || return
        json_init
        json_load "$(cat $cfg)"

        json_get_var value wifi_driver_type
        echo $value
        return 0
}
get_support_wisp_json() {
        local cfg="/etc/product_feature"
        local value
        [ -s "$cfg" ] || return
        json_init
        json_load "$(cat $cfg)"

        json_get_var value wifi_driver_type
        echo $value
        return 0
}

wisp_scan()
{
	local ifname=$1
	test -z $ifname && return
	iwpriv $ifname set SiteSurvey=1
	sleep 5
        if [ $wifi_driver_type -eq 1 ];then
		if [ x"rai0" == x"$ifname" ];then
			iwpriv $ifname get_site_survey | grep -v Total | grep -v ExtCH | grep -v get_site_survey | cut -c 5- >>/tmp/wifi_list
		else
			iwpriv $ifname get_site_survey | grep -v Total | grep -v ExtCH | grep -v get_site_survey>>/tmp/wifi_list
		fi
	else
		iwpriv $ifname get_site_survey | grep -v Total | grep -v RsrReqCap | grep -v get_site_survey>>/tmp/wifi_list
	fi
}
wisp_scan_all()
{
	! test -f /tmp/wifi_list && touch /tmp/wifi_list
	! test -f /tmp/wifi_bak_list && touch /tmp/wifi_bak_list
	echo "1" >/tmp/wifi_scan.lock
	cp /tmp/wifi_list /tmp/wifi_bak_list
	echo "" >/tmp/wifi_list
        if [ $wifi_driver_type -eq 1 ];then
	    wisp_scan "ra0"
	    wisp_scan "rai0"
	else
            echo "ra0 scan"
	    wisp_scan "ra0"
	    wisp_scan "rax0"
	fi	
	echo "0" >/tmp/wifi_scan.lock
}

wisp_reload_config()
{
	local ssid
	local password
	local bssid
	local ifname
	ifname=`uci get network.wan.device`

	echo $ifname |grep "apcli"
	if [ $? -ne 0 ];then
		wlog "ifname error $ifname"
		return
	fi
	cat /proc/uptime  | awk -F. '{print $1}' > /tmp/wifi_connect_status
        if [ $wifi_driver_type -eq 1 ];then
		echo "apclii0 down"
		ifconfig apclii0 0.0.0.0
		ifconfig apclii0 down
	else
		echo "apcli0 down"
		ifconfig apcli0 0.0.0.0
		ifconfig apcli0 down
        fi

	ifconfig apclix0 0.0.0.0
	ifconfig apclix0 down
	ifconfig apclii0 0.0.0.0
	ifconfig apclii0 down
	ifconfig apcli0 0.0.0.0
	ifconfig apcli0 down
	ifconfig $ifname up
	ssid=`uci get network.wan.ap_ssid`
	password=`uci get network.wan.ap_password`
	bssid=`uci get network.wan.ap_bssid`
	local security=`uci get network.wan.ap_security`

	if [ x"" == x"$ssid" -o x"" == x"$bssid" -o x"" == x"$security" ];then
		wlog "wisp uci config error"
		return
	fi
	
	local auth_type=`echo $security | awk -F/ '{print $2}'`
	local auth_mode=`echo $security | awk -F/ '{print $1}'`
	wlog "ifname=$ifname, ssid=$ssid, bssid=$bssid, password=$password, security=$security"

iwpriv $ifname set ApCliEnable=0
#iwpriv $ifname set Channel=149
iwpriv $ifname set ApCliAuthMode=$auth_mode
iwpriv $ifname set ApCliEncrypType=$auth_type
iwpriv $ifname set ApCliSsid="$ssid"
iwpriv $ifname set ApCliEnable=1
iwpriv $ifname set ApCliAutoConnect=3
iwpriv $ifname set ApCliWPAPSK="$password"
	wlog "reload config ok..."
}

get_support_wisp_json
if [ $? -ne 0 ];then
    echo "not support wisp" 
    exit 1
fi
d_type=`get_wifi_driver_type_json`
if [ $? -eq 0 ];then
    wifi_driver_type=$d_type
else
    wifi_driver_type=2
fi
echo "wifi_driver type = $wifi_driver_type"

case $1 in
    "scan")
	echo "scan"
	wisp_scan_all
    ;;
    "reload")
	wisp_reload_config
    ;;
    *)
	echo "usage"
    ;;
esac
