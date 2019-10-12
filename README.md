# Openvpn-connector-script

This bash script is a handy way of making sure your vpn tunnel is always up, it will try to reconnect once it detects it as down. By default I have it setup to work with ipvanish.

### dependencies (should be in your repos)
```
expect
openvpn
curl
whois
ping
```

### optional dependencies (should be in your repos)
```
toilet
pass
```

`toilet` is only there as a kinda welcome you can just comment out the 3rd line in `vpn.sh`.


`pass` is highly recommended and used here to store your vpn password. If you dont want to set it up you can simply pass in your password in plain text ( this is fine if you are ok with a big boi roasting you for keeping passwords in plain text ). Here is a nice guide to setup pass https://www.passwordstore.org/


You will also need to create a gpg key to use with  pass, here is a nice guide https://www.cyberciti.biz/tips/linux-how-to-create-our-own-gnupg-privatepublic-key.html


If you dont wanna do that then change line 6 in `vpn` to `sudo $SCRIPTPATH/vpn_runner.sh "YOUR_PASSWORD"`


## configuration 
#### `vpn`
In `vpn` change line 6 to whatever your password entry is in pass.

#### `vpn_runner.sh`
By default this is configured to use IPVanish, this is done by simply checking if your ip belongs to IPVanish by running whois in `vpn.sh` line 52.


You can try to change it to `checkisp=$(whois $ip | grep nord)` for example if you use NordVPN although I havent tried.


You can also change how fast the script checks if the tunnel is up by changing `aggressive_checker` in line 5. 


The `wait_for_vpn_to_become_active` variable underneath is used to wait for openvpn to become active again after killing it. This is set at 30 by default since if you set it too low the script will kill openvpn before it got a chance to start up properly and recieve a new ip.

#### `vpn-helper.sh`
In `vpn-helper.sh` change line 2 to point to your vpn providers openvpn config file. 


In `vpn-helper.sh` change line 6 to your email that you use to login to openvpn.

## Update
##### V1 - stability
Split vpn.sh into two files. `vpn` to get access to user pass store and `vpn_runner.sh` makes sure it runs as root and grabs password as argument.


This elliminates the need to re-enter the password for your gpg key ocassionaly after restarting openvpn.


Script seemed to kill vpn too easily under heavy download load. To help mitigate this the `testnetwork` function pings 3 fairly reliable websites instead of just one. (So far the tunnel stays up way longer even with heavy load)


Ctrl + C is now handled and openvpn is killed before exiting script.


The three scripts should now be able to find themselves (Using absolute path) if they are in the same directory. So if the scripts are located in `/home/user/scripts/vpn` for example you can call `vpn` without `cd`ing into the directory.
