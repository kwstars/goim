#!/bin/bash

# Get the local IP address
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Check if the local IP address is empty
if [ -z "$LOCAL_IP" ]; then
  echo "Error: Unable to get local IP address"
  exit 1
fi

# Update the IP address in the configuration files
find goim/examples/javascript -type f -exec sed -i "s/sh\.tony\.wiki/$LOCAL_IP/g; s/api\.goim\.io/$LOCAL_IP/g" {} +

echo "Updated all files in goim/examples/javascript. Replaced 'sh.tony.wiki' with $LOCAL_IP"
