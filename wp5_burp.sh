#!/bin/bash
#define variables

echo "$(tput setaf 3)  _       ___ _______    ____  _                              __   "
echo " | |     / (_) ____(_)  / __ \\(_)___  ___  ____ _____  ____  / /__ "
echo " | | /| / / / /_  / /  / /_/ / / __ \/ _ \/ __ '/ __ \/ __ \/ / _ \\"
echo " | |/ |/ / / __/ / /  / ____/ / / / /  __/ /_/ / /_/ / /_/ / /  __/"
echo " |__/|__/_/_/   /_/  /_/   /_/_/ /_/\___/\__,_/ .___/ .___/_/\___/ "
echo " $(tput sgr0) OWN the Network                            $(tput setaf 3)/_/   /_/$(tput sgr0)       v2.2"
echo ""

# Optimized for wireless connetions
echo -n "Wireless connection ? [wlan0]: "
read internet
if [[ $internet == '' ]]; then
	ifconfig wlan0 172.16.42.42
else
	ifocnfig $internet 172.16.42.42
fi

echo -n "Pineapple Netmask [255.255.255.0]: "
read pineapplenetmask
if [[ $pineapplenetmask == '' ]]; then 
pineapplenetmask=255.255.255.0 #Default netmask for /24 network
fi

echo -n "Pineapple Network [172.16.42.0/24]: "
read pineapplenet
if [[ $pineapplenet == '' ]]; then 
pineapplenet=172.16.42.0/24 # Pineapple network. Default is 172.16.42.0/24
fi

echo -n "Interface between PC and Pineapple [eth0]: "
read pineapplelan
if [[ $pineapplelan == '' ]]; then 
pineapplelan=eth0 # Interface of ethernet cable directly connected to Pineapple
fi

echo -n "Interface between PC and Internet [wlan0]: "
read pineapplewan
if [[ $pineapplewan == '' ]]; then 
pineapplewan=wlan0 #i.e. wlan0 for wifi, ppp0 for 3g modem/dialup, eth0 for lan
fi

temppineapplegw=`netstat -nr | awk 'BEGIN {while ($3!="0.0.0.0") getline; print $2}'` #Usually correct by default
echo -n "Internet Gateway [$temppineapplegw]: "
read pineapplegw
if [[ $pineapplegw == '' ]]; then 
pineapplegw=`netstat -nr | awk 'BEGIN {while ($3!="0.0.0.0") getline; print $2}'` #Usually correct by default
fi

echo -n "IP Address of Host PC [172.16.42.42]: "
read pineapplehostip
if [[ $pineapplehostip == '' ]]; then 
pineapplehostip=172.16.42.42 #IP Address of host computer
fi

echo -n "IP Address of Pineapple [172.16.42.1]: "
read pineappleip
if [[ $pineappleip == '' ]]; then 
pineappleip=172.16.42.1 #Thanks Douglas Adams
fi

#Display settings
#echo Pineapple connected to: $pineapplelan
#echo Internet connection from: $pineapplewan
#echo Internet connection gateway: $pineapplegw
#echo Host Computer IP: $pineapplehostip
#echo Pineapple IP: $pineappleip
#echo Network: $pineapplenet
#echo Netmask: $pineapplenetmask

# Use Burp suite?
echo -n "Use IP forwarding port 80 to Burp port 8080? [Y/n]: "
read $forwarding80
if [[ $forwarding80 == '' || $forwarding80 == 'Y' ]]; then
       $forwarding80 = 'Y';
fi

echo -n "Use IP forwarding port 443 to Burp port 8080? [Y/n]: "
read $forwarding443
if [[ $forwarding443 == '' || $forwarding443 == 'Y' ]]; then
       $forwarding443 = 'Y';
fi       

echo ""
echo "$(tput setaf 6)     _ .   $(tput sgr0)        $(tput setaf 7)___$(tput sgr0)          $(tput setaf 3)\||/$(tput sgr0)   Internet: $pineapplegw - $pineapplewan"
echo "$(tput setaf 6)   (  _ )_ $(tput sgr0) $(tput setaf 2)<-->$(tput sgr0)  $(tput setaf 7)[___]$(tput sgr0)  $(tput setaf 2)<-->$(tput sgr0)  $(tput setaf 3),<><>,$(tput sgr0)  Computer: $pineapplehostip"
echo "$(tput setaf 6) (_  _(_ ,)$(tput sgr0)       $(tput setaf 7)\___\\$(tput sgr0)        $(tput setaf 3)'<><>'$(tput sgr0) Pineapple: $pineapplenet - $pineapplelan"


#Bring up Ethernet Interface directly connected to Pineapple
ifconfig $pineapplelan $pineapplehostip netmask $pineapplenetmask up

# Enable IP Forwarding
echo '1' > /proc/sys/net/ipv4/ip_forward
#echo -n "IP Forwarding enabled. /proc/sys/net/ipv4/ip_forward set to "
#cat /proc/sys/net/ipv4/ip_forward

#clear chains and rules
iptables -X
iptables -F
#echo iptables chains and rules cleared

#setup IP forwarding
iptables -A FORWARD -i $pineapplewan -o $pineapplelan -s $pineapplenet -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE
#echo IP Forwarding Enabled

#remove default route
route del default
#echo Default route removed

#add default gateway
route add default gw $pineapplegw $pineapplewan
#echo Pineapple Default Gateway Configured

#instructions
#echo All set. Now on the Pineapple issue: route add default gw $pineapplehostip br-lan

#ping -c1 $pineappleip
#if [ $? -eq 0 ]; then
#echo "ICS configuration successful."
#echo "Issuing on Pineapple: route add default gw $pineapplehostip br-lan"
#echo "  ssh root@$pineappleip 'route add default gw '$pineapplehostip' br-lan'"
#echo "Enter Pineapple password if prompted"
#ssh root@$pineappleip 'route add default gw '$pineapplehostip' br-lan'
#fi

echo ""
echo "Browse to http://$pineappleip:1471"
echo ""

if [[ $forwarding80 == 'Y' ]]; then
	iptables -t nat -A PREROUTING -i $internet -m tcp -p tcp --dport 80 -j DNAT --to-destination 172.16.42.42:8080;
fi

if [[ $forwarding443 == 'Y' ]]; then
	iptables -t nat -A PREROUTING -i $internet -m tcp -p tcp --dport 443 -j DNAT --to-destionation 172.16.42.42.8080;
fi


