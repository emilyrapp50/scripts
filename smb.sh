#!/bin/bash

#Colors :D (ANSI escape codes)
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

# Clear/create output file
> remediatedsmb.txt
> checkdecomm.txt

# Iterate
while read -r ip; do
	echo -e "${GREEN}Running: nmap -p445 --script smb-protocols -Pn $ip${RESET}"

	# SMBv1 scan
	smb_scan=$(nmap -p445 --script smb-protocols -Pn "$ip")

	# Dangerous?
	if echo "$smb_scan" | grep -iq 'dangerous'; then
		echo -e "${RED}$ip has SMBv1 enabled${RESET}"
		continue
	fi

	# No version info
 	if ! echo "$smb_scan" | grep -q '2:0:2'; then
		echo -e "${YELLOW}$ip has no SMB version info${RESET}"
		echo "$ip" >> checkdecomm.txt
		continue
	fi

	# If not dangerous, and versioninfo exists, remediated
	echo -e "$ip does not have SMBv1 enabled"
	echo "$ip" >> remediatedsmb.txt

done < smblist.txt

echo "Done."
echo -e "Remediated IP's have been written to remediatedsmb.txt."
echo -e "IP's with no SMB version info have been written to checkdecomm.txt."
echo -e "-------------------------------------------------------------------"

# Check?
read -p "Would you like to check the remediated IP's? y/n: " choice

if [ "$choice" == "y" ]; then
	# Iterate
	while read -r ip; do
		echo -e "${GREEN}Checking $ip...${RESET}"
		nmap -p445 --script smb-protocols -Pn "$ip"
	done < remediatedsmb.txt
else
	echo -e "${GREEN}Exiting without checking${RESET}"
	fi
