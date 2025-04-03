#!/bin/bash

set -x  # Enable debug mode

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required commands
for cmd in nc ss-local python3; do
    if ! command_exists "$cmd"; then
        echo "Error: $cmd is not installed"
        exit 1
    fi
done

# Check if config file exists
if [ ! -f /app/config/shadowsocks.json ]; then
    echo "Error: shadowsocks.json not found"
    ls -la /app/config/
    exit 1
fi

# Check if ss-local is running
if ! pgrep -x "ss-local" > /dev/null; then
    echo "Error: ss-local is not running"
    ps aux | grep ss-local
    exit 1
fi

# Wait for ss-local to be ready with timeout
echo "Waiting for ss-local to be ready..."
timeout=60  # Increased timeout to 60 seconds
counter=0
while ! nc -z 127.0.0.1 1080; do
    sleep 1
    counter=$((counter + 1))
    echo "Waiting for ss-local... ($counter/$timeout seconds)"
    if [ $counter -ge $timeout ]; then
        echo "Timeout waiting for ss-local to be ready"
        echo "Checking ss-local status..."
        ps aux | grep ss-local
        echo "Checking port status..."
        netstat -tulpn | grep 1080
        echo "Checking ss-local logs..."
        cat /var/log/supervisor/ss-local-stderr.log
        exit 1
    fi
done
echo "ss-local is ready"

# Generate PAC file
echo "Generating PAC file..."
if ! /app/update_pac_cron.sh; then
    echo "Error: Failed to generate PAC file"
    echo "Checking gfwlist2pac installation..."
    pip list | grep gfwlist2pac
    echo "Checking directory permissions..."
    ls -la /app/
    exit 1
fi

# Check if PAC file was generated
if [ ! -f /app/gfwlist.pac ]; then
    echo "Error: PAC file was not generated"
    echo "Checking directory permissions..."
    ls -la /app/
    exit 1
fi

# Start HTTP server
echo "Starting HTTP server..."
cd /app
exec python3 -m http.server 8080