#!/bin/bash

toilet -f big -t " VPN "

aggressive_checker=5 # seconds to chech if vpn is up
wait_for_vpn_to_become_active=30 # seconds

# get path to call helper properly
SCRIPT="$(realpath $0)"
SCRIPTPATH="$(dirname $SCRIPT)"


testpass() {
	if [ -z "$PASSWORD" ];
	then
		echo "Error getting password" 
		exit 1

	fi	
}

launchvpn() {
	testpass
	$SCRIPTPATH/vpn-helper.sh $PASSWORD
}

testnetwork() {
	upcount=0
	ping wikipedia.com -c 1 > /dev/null 2>&1 && upcount=$(( $upcount + 1 ))

	sleep 0.6

	ping ipvanish.com -c 1 > /dev/null 2>&1 && upcount=$(( $upcount + 1 ))

	sleep 0.4

	ping stackoverflow.com -c 1 > /dev/null 2>&1 && upcount=$(( $upcount + 1 ))

	if [ "$upcount" -ge "1" ]
	then
		return 0
	else
		return 1
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

loop(){
	while [ 1 ]
	do
		testUP
		if [ $? -ne 0 ]
			then
				echo -e "killing and restarting vpn\n"
				killall openvpn
				sleep 1
				launchvpn
				sleep $wait_for_vpn_to_become_active
			else
				echo "everything is ok @ $(date)"	
		fi
		echo "___________________________________"
		sleep $aggressive_checker
	done
}

checkstart(){
	if [ "$EUID" -ne 0 ]
		  then echo "Please run as root"
		  exit 2
	else
		return 0	  
	fi
}

exit_cleanly(){
	unset PASSWORD
	echo "Exiting VPN.... OpenVPN will be killed"
	killall openvpn
	echo "Goodbye"
	exit 0
}

main(){
	PASSWORD=$@
	checkstart && loop
}

trap "exit_cleanly" 2

main $@ # can use $1 if your pass doesnt have spaces
	


