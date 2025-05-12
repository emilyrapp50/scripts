#!/bin/bash

#this thing gets host names and open ports
#Colors :D (ANSI escape codes)
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

#clear output/create file
> hostnames.txt

#hostname
resolve_hostname() {
	ip=$1
	hostname=$(nmap -sL $ip | grep 'Nmap scan report' | awk '{print $5}')

#	if [ "$hostname" == '$ip' ]; then
#		echo -e "${RED} $ip: No hostname found ${RESET}"
#
#
#
#	else
		echo -e "$ip: ${YELLOW}$hostname${RESET}"
		echo "$hostname" >> hostnames.txt
		#echo "$ip: $hostname" >> hostnames.txt
#	fi


}

#ports and services
ssl_hostname() {
        ip=$1
        echo -e "${CYAN}Looking for hostname on $ip: ${RESET}"
                nmap --script ssl-cert "$ip" | grep 'ssl-cert: Subject: commonName='
}

#ports and services
scan_ports() {
	ip=$1
	echo -e "${CYAN}Scanning $ip for open ports and services ${RESET}"
		nmap -sV "$ip" | grep -A 100 'Host'
}

#-Pn
run_pn_scan() {
	ip=$1
	echo -e "${CYAN}Running without host discovery: $ip ${RESET}"
		nmap -sV -Pn "$ip" | grep -A 100 'Host'
}
#-sC -sV -O
run_version_scan() {
	ip=$1
	echo -e "${CYAN}Scanning $ip for versions and OS (-sC -sV -O), this may take some time...${RESET}"
		sudo nmap -sC -sV -O -Pn "$ip" | grep -A 100 'Host'
}

#user input
read -p "$(echo -e ${GREEN}Enter an IP address, or a filename with IP addresses: ${RESET} )" input 

#file or ip
if [ -f "$input" ]; then
	#if file, iterate 
	while IFS= read -r ip; do
		resolve_hostname "$ip"
	done < "$input"
else

	#single ip
	resolve_hostname "$input"
fi

#SSL cert hostname
read -p "$(echo -e ${GREEN}Would you like to look for hostnames in the SSL cert? y/n: ${RESET} )" cert_scan_choice

#y
if [ "$cert_scan_choice" == "y" ]; then
        if [ -f "$input" ]; then
                while IFS= read -r ip; do
                        ssl_hostname "$ip"
                done < "$input"
        else
                ssl_hostname "$input"
        fi
else
        echo "Skipped."
fi

#open ports/services?
read -p "$(echo -e ${GREEN}Would you like to scan for open ports and services? y/n: ${RESET} )" scan_choice

#y
if [ "$scan_choice" == "y" ]; then
	if [ -f "$input" ]; then
		while IFS= read -r ip; do
			scan_ports "$ip" 
		done < "$input" 
	else
		scan_ports "$input"
	fi
else
	echo "Skipped."
fi

#-Pn? 
read -p "$(echo -e ${GREEN}Run without host discovery? y/n: ${RESET} )" pn_scan_choice

#y -Pn
if [ "$pn_scan_choice" == "y" ]; then
	if [ -f "$input" ]; then
		while IFS= read -r ip; do
			run_pn_scan "$ip"
		done < "$input"
	else
		run_pn_scan "$input"
	fi
else
	echo "Skipped."
fi

#-sC -sV -O
read -p "$(echo -e ${GREEN}Would you like to intense scan for versions and OS? y/n: ${RESET} )" ver_scan_choice

#y -sC -sV -O
if [ "$ver_scan_choice" == "y" ]; then
	if [ -f "$input" ]; then
		while IFS= read -r ip; do
			run_version_scan "$ip"
		done < "$input"
	else
		run_version_scan "$input"
	fi
else
	echo "Skipped."
fi
