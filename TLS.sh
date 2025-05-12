#!/bin/bash

GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

run_nmap() {
	local ip="$1"
	echo -e "${GREEN}Running: nmap --script ssl-enum-ciphers -p443 ${RESET}"

	nmap_output=$(nmap --script ssl-enum-ciphers -p 5666 -Pn "$ip")

	tls_versions=$(echo "$nmap_output" | grep -oP 'TLSv[0-=9]+\.[0-9]+'| sort -u)

	echo "IP: $ip"
	echo "Supported TLS Versions:"
	if [ -z "$tls_versions" ]; then
		echo "No TLS versiond detected."
	else
		echo "$tls_versions"
	fi
	echo "--------------------"
}

while IFS= read -r ip; do
	run_nmap "$ip"
done < "iplist.txt"
