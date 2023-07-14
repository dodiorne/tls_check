#!/bin/bash

# Check if the input file is provided as a command-line argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

input_file=$1

# Function to check SSL/TLS versions
check_ssl_tls_versions() {
  address=$1
  port=$2

  # Perform the SSL/TLS version check using nmap
  result=$(nmap --script ssl-enum-ciphers -p "$port" "$address" | grep -E "SSLv[12]|SSLv3|TLSv1\.0|TLSv1\.1")

  if [[ "$result" =~ "SSLv1" ]]; then
    echo "SSLv1 enabled on $address:$port"
  fi

  if [[ "$result" =~ "SSLv2" ]]; then
    echo "SSLv2 enabled on $address:$port"
  fi

  if [[ "$result" =~ "SSLv3" ]]; then
    echo "SSLv3 enabled on $address:$port"
  fi

  if [[ "$result" =~ "TLSv1.0" ]]; then
    echo "TLS 1.0 enabled on $address:$port"
  fi

  if [[ "$result" =~ "TLSv1.1" ]]; then
    echo "TLS 1.1 enabled on $address:$port"
  fi
}

# Read each line from the input file
while IFS=: read -r address port; do
  # Skip empty lines
  if [[ -z "$address" ]]; then
    continue
  fi

  # Run the check_ssl_tls_versions function
  check_ssl_tls_versions "$address" "$port"
done < "$input_file"
