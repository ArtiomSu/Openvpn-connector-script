#!/bin/bash

toilet -f big -t " VPN "

aggressive_checker=10 # seconds to chech if vpn is up
wait_for_vpn_to_become_active=30 # seconds

launchvpn() {
	sudo ./scrips/vpn-helper.sh "$(pass vpn/username@gmail.com)"
}

testnetwork() {
	ping wikipedia.com -c 1 > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		return 1
	else
		return 0	
	fi
}

testIP() {
	ip=$(curl -s ifconfig.me)
	echo "My ip is $ip"

	checkisp=$(whois $ip | grep IPVanish)
	if [ ! -z "$checkisp" ]; then
	# it is from ipvanish 	
	echo "ip is from ipvanish"
	return 0
	else
	echo "ip IS INCORRECT"
	return 1
	fi	
}

testUP(){
	testnetwork
	if [ $? -ne 0 ]
	then
		return 1
	else
		testIP
		if [ $? -ne 0 ]
		then
			return 1
		else
			return 0	
		fi	
	fi
}

while [ 1 ]
do
	testUP
	if [ $? -ne 0 ]
		then
			echo -e "killing and restarting vpn\n"
			sudo killall openvpn
			sleep 1
			launchvpn
			sleep $wait_for_vpn_to_become_active
		else
			echo "everything is ok @ $(date)"	
	fi
	echo "___________________________________"
	sleep $aggressive_checker
done	


