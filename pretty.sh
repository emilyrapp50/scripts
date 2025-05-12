#!/bin/bash

input_file="hosts.txt"
output_file="output.txt"

grep -oE '"label":\s*"[^"]+"' "$input_file" | sed -E 's/"label":\s*"([^"]+)"/\1/' > "$output_file"

echo "Hostnames saved to $output_file"
