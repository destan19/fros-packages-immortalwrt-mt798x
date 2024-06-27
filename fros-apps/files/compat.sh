#!/bin/sh

compat_handle()         
{                       
        local ret       
        ret=`uci get fros.system.hwnat`
        if [ x"$ret" != x"1" ];then    
                echo "disable hwnat"   
                test -d /sys/kernel/debug/hnat  && {
                        echo 0 >/sys/kernel/debug/hnat/hook_toggle
                }                                                 
                test -d /sys/kernel/debug/ecm/ && {               
                        echo "1000000" > /sys/kernel/debug/ecm/ecm_classifier_default/accel_delay_pkts
                }                                                                                     
        else                                                                                          
                echo "enable hwnat"                                                                   
                test -d /sys/kernel/debug/hnat  && {                                                  
                        echo 1 >/sys/kernel/debug/hnat/hook_toggle                                    
                }                                                                                     
                test -d /sys/kernel/debug/ecm/ && {                                                   
                        echo "20" > /sys/kernel/debug/ecm/ecm_classifier_default/accel_delay_pkts     
                }                                                                                     
                                                                                                 
        fi                                                                                       
        ret=`uci get fros.system.ipv6`                                                           
        if [ x"$ret" == x"1" ];then                                                              
            echo "enable ipv6 dhcps"                                                             
            /etc/init.d/odhcpd start                                                             
            /etc/init.d/odhcpd enable                                                            
        else                                                                                     
            echo "disable ipv6 dhcps" 
            /etc/init.d/odhcpd stop   
            /etc/init.d/odhcpd disable
        fi                            
                                      
} 

compat_handle
