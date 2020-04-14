#!/usr/bin/env python3

import os
import time


def intro():
    print("This tool was meant to automate all begining enumeration for a pentest.")
    print("It includes the following:")
    print("1. Opens tmux windows for every scan")
    print("2. Uses nmap and saves the result to the current directory.")
    print("3. Gobuster and Nikto for directory and vulnerabilities")
    print("4. Runs Subdomain Recon tool also included, this tool gathers subdomains for the domain, gets multisub domains from them, and captures screenshots from the alive domains that were found using EyeWitness")
    print('\n'.join(' ' * (7-i) + '    * ' * i for i in range(1, 7)))
    print('\n'.join(' ' * (7-i) + '    * ' * i for i in range(7,0,-1)))
    print(" ")
    print("Made by ~~PacMan~~")
    print('=' * 10 +"STARTING"+'=' * 10)

def start_tmux(session):
    #Start a tmux session
    os.system(f"""gnome-terminal --tab -e "bash -c 'tmux new -s {session}';bash" & """)

def start_nmap(syntax,domain,session):
    #Check special requironments
    if syntax:
        if ',' in syntax:
            syntax = syntax.replace(',',' ')
    #Execute nmap on a new tmux window
    os.system(f"tmux new-window -n NMAP -t {session}")
    os.system(f"tmux select-pane -t 1 && tmux send 'nmap {syntax} {domain} > nmap_scan.txt' ENTER")

def start_nikto(domain,port,session):
    #start Nikto vulnerability scan..
    os.system(f"tmux new-window -n NIKTO -t {session}")
    os.system(f"tmux select-pane -t 2 && tmux send 'nikto -url {domain} -port {port} -o nikto_scan.txt && mv nikto_scan.txt ./scans' ENTER")

def start_gobuster(domain,port,session):
    #start gobuster on a new tmux window
    os.system(f"tmux new-window -n GOBUSTER -t {session}")
    if port == 443:
        domain = 'https://' + domain
        os.system(f"tmux select-pane -t 3 && tmux send 'gobuster dir -u {domain} -k -w ./setup/directory-list-2.3-medium.txt -t 10 --wildcard' ENTER")
    elif port == 80:
        domain = 'http://' + domain
        os.system(f"tmux select-pane -t 3 && tmux send 'gobuster dir -u {domain} -w ./setup/directory-list-2.3-medium.txt -t 10 --wildcard' ENTER")
    else:
        domain = 'http://'+ domain + f':{port}'
        os.system(f"tmux select-pane -t 3 && tmux send 'gobuster dir -u {domain} -w ./setup/directory-list-2.3-medium.txt -t 10 --wildcard' ENTER")

def start_DnsRecon(domain,session):
    #start DNS_Recon tool
    os.system(f"tmux new-window -n DNS -t {session}")
    os.system(f"tmux select-pane -t 3 && tmux send './Recon_Subs.sh {domain}' ENTER")

def main():
    intro()

    #------------INPUTS-------------

    session = input("Enter the name of the tmux session you would like: ")
    #Just for having a name for the sesion..
    if session == '':
        session = 'Default'
    domain = input("Enter the Domain\IP not the FULL address (without the url header): ")
    port = int(input("Enter port for the domain: "))
    directory = input("Enter the full path directory which you want to be originated from: ")
    n_map= input("Any special syntax for nmap?, Enter them as follow (examp:-Pn,-sC,-O...) ---> ")

    #-------------------------------
    start_tmux(session)
    time.sleep(2)
    start_nmap(n_map,domain,session)
    time.sleep(2)
    start_nikto(domain,port,session)
    time.sleep(2)
    start_gobuster(domain,port,session)
    time.sleep(2)
    start_DnsRecon(domain,session)

main()
