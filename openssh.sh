#!/bin/bash

GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

run_nmap() {
        local ip="$1"

        nmap_output=$(nmap -sV -p22 "$ip")

        ssh_versions=$(echo "$nmap_output" | grep -oP 'OpenSSH \K[0-9]+(\.[0-9])'| sort -u)

	port_num=$(echo "$nmap_output" | grep -oP '^\d+/tcp(?=.*OpenSSH)' | cut -d'/' -f1)

	echo -e "${GREEN}OpenSSH Version on $ip:$port_num ${RESET} "
	if [ -z "$ssh_versions" ]; then
                echo "No OpenSSH version detected."
        else
                echo "$ssh_versions"
        fi
        echo "--------------------"
}

while IFS= read -r ip; do
        run_nmap "$ip"
done < "iplist.txt"
