#!/bin/bash
#Changed sublist3r to work on silent mode inside the actual script

#making sure there is an argument
if [ $# -eq 0  ];then
    echo "Usage:  ./script.sh <domain>"
    echo "Example: ./script.sh yahoo.com"
    exit 1
fi
#make directory for nmap scans
if [ ! -d "scans" ];then
    mkdir scans
fi


#make sure that there is a directory to store subdomains
if [ ! -d "new_subs" ]; then
    mkdir new_subs
fi

#make sure there is an eyewitness directory
if [ ! -d "eyewitness_results" ];then
    mkdir eyewitness_results
fi

echo "==============STARTING=============="
echo " "
echo "This is a smaill automated tool to help the DNS Recon. "
echo "At the end of it you will have a few directories with useful sources such as:"
echo "1- Screenshots of all the subdomins that were found reilable using EyeWitness tool"
echo "2- nmap scans of popular ports of the reliable subdomains"
echo "3- a list of the subnets that were found... ENJOY !!!!"
echo " "
echo "Gathering Subdomains with 'Sublister'..."
sublist3r -t 10 -d $1 -o final.txt
echo $1 >>final.txt

echo "======Compiling Sublists for domain========"

echo "Gathering subdomains for the results (This may take a while)..."
for domain in $(cat final.txt); do sublist3r -t 10 -d $domain -o ./new_subs/"$domain.txt"; done

echo "=======Probing for alive domains======== "
cat final.txt | httprobe -s -p https: | sed 's/:$//' > probed.txt

echo "=======Scanning for open ports====="
nmap -iL final.txt -T 5 -oA ./scans/scanned.txt

echo "=======Running EyeWitness======="
./setup/EyeWitness/EyeWitness.py -f $pwd/probed.txt -d $1 --threads 5
mv ./setup/EyeWitness/$1 $pwd/eyewitness_results/

echo " "
echo " "
echo "===========Exiting============"
