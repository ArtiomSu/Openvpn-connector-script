#!/usr/bin/expect -f
spawn sudo openvpn --config ./vpn/configs/UK/London/ipvanish-UK-London-lon-a14.ovpn --ping 5 --ping-restart 10 --verb 3 --persist-tun
match_max 100000
set pass [lindex $argv 0];
expect "*?sername:*"
send -- "username@gmail.com"
send -- "\r"
expect "*?assword:*"
send -- $pass
send -- "\r"
expect eof