#!/bin/sh
. /lib/functions.sh

CUSTOM_FEATURE_FILE="/tmp/custom_feature.cfg"
count1=0
count2=0
count3=0
count4=0
count5=0
count6=0
count7=0
count8=0
count9=0

handle_custom()
{
	local config="$1"
 	config_get name $config  name
 	config_get type $config  type
 	config_get host1 $config  host1
 	config_get host2 $config  host2
 	config_get host3 $config  host3
		
	a=`echo $(eval echo  '$'count$type)`
	a=`expr $a + 1`                  
	echo "type:$type count=$a"
	eval count$type=$a
	echo "i"
	id=`expr $type \* 1000 + 999 - $a`
	echo "id = $b, type = type"
		
	feature="$id $name:[tcp;;;$host1;;"
	if [ x"" != x"$host2" ];then
		feature="${feature},tcp;;;$host2;;"
	fi
	if [ x"" != x"$host3" ];then
		feature="${feature},tcp;;;$host3;;"
	fi
	feature="${feature}]"
	echo "feature=$feature"
	echo "$feature">>$CUSTOM_FEATURE_FILE
}
echo "">$CUSTOM_FEATURE_FILE
config_load oaf_feature
config_foreach handle_custom "custom_rule"