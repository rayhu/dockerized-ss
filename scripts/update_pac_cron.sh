#!/bin/bash

set -x  # Enable debug mode

echo "$(date): Updating PAC..."

# Check if gfwlist2pac is installed
if ! command -v gfwlist2pac >/dev/null 2>&1; then
    echo "Error: gfwlist2pac is not installed"
    pip list | grep gfwlist2pac
    exit 1
fi

# Check if user rule file exists
if [ ! -f /app/gfwlist.user.txt ]; then
    echo "Warning: gfwlist.user.txt not found, creating empty file"
    touch /app/gfwlist.user.txt
fi

# Generate PAC file
echo "Generating PAC file with gfwlist2pac..."
gfwlist2pac \
    --proxy="SOCKS5 127.0.0.1:1080;" \
    --user-rule=/app/gfwlist.user.txt \
    --output=/app/gfwlist.pac \
    --from-gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"

if [ $? -ne 0 ]; then
    echo "Error: Failed to generate PAC file"
    exit 1
fi

# Verify PAC file was generated
if [ ! -f /app/gfwlist.pac ]; then
    echo "Error: PAC file was not generated"
    exit 1
fi

echo "$(date): PAC Updated successfully"