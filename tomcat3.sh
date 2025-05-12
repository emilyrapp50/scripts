#!/bin/bash

#what tomcat doin
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

#lol
echo ""
base64 -d <<<"ICAgICAgICAg77yP77ye44CAIOODlQ0KICAgICAgICAgfCDjgIBf44CAX3wgDQogICAgICAg77yPYCDjg5/vvL9444OOIA0KICAgICAgL+OAgOOAgOOAgOOAgCB8DQogICAgIC/jgIAg44O944CA44CAIO++iQ0KICAgICDilILjgIDjgIB844CAfOOAgHwNCu+8j++/o3zjgIDjgIAgfOOAgHzjgIB8DQoo77+j44O977y/X+ODvV8pX18pDQrvvLzkuowp"
echo ""
echo "What the cat doin?"


#nmap funtion
run_nmap() {
        ip=$1
	port=$2
        echo -e "${GREEN}Running: nmap -sV -sC -Pn ${RESET}"
        	nmap_output=$(nmap -sV -sC -Pn -p $port $ip | grep 'Tomcat')
		echo "IP: $ip"
		echo "Port: $nmap_port"
		echo "$nmap_output"
		echo "---------------"


}
#curl function
run_curl() {
	ip=$1
	port=$2
	echo -e "${GREEN}Running: curl -s ${RESET}"
		curl_output=$(curl -s --connect-timeout 5 http://$ip:$port/test | grep -Eo 'Apache Tomcat/[^ ]+ -')
		echo "IP: $ip"
		echo "Port: $curl_port"
		echo "$curl_output"
		echo "---------------"
}


#user defined var for host
echo ""
read -p "$(echo -e ${GREEN}Enter an IP address, or a filename with IP addresses: ${RESET} )" host


#want nmap?
read -p "$(echo -e ${GREEN}Want nmap? y/n: ${RESET} )" run_nmap_choice
if [ "$run_nmap_choice" == "y" ]; then
read -p "$(echo -e ${GREEN}Enter port: ${RESET} )" nmap_port
        if [ -f "$host" ]; then
                while IFS= read -r ip; do
                        run_nmap "$ip" "$nmap_port"
                done < "$host"
        else
                run_nmap "$host" "$nmap_port"
        fi
else
        echo "Skipped."
fi


#want curl?
read -p "$(echo -e ${GREEN}Want curl? y/n: ${RESET} )" run_curl_choice
if [ "$run_curl_choice" == "y" ]; then
read -p "$(echo -e ${GREEN}Enter port: ${RESET} )" curl_port
	if [ -f "$host" ]; then
		while IFS= read -r ip; do
			run_curl "$ip" "$curl_port"
		done < "$host"
	else
		run_curl "$host" "$curl_port"
	fi
else
	echo "Skipped."
fi
