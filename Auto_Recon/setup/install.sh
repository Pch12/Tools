#!/bin/bash
git clone https://github.com/tomnomnom/httprobe.git
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
sudo apt-get install golang-go
go get -u github.com/tomnomnom/httprobe/
cp /root/go/bin/httprobe /usr/bin
./EyeWitness/setup/setup.sh


