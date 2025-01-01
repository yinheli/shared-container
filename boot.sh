#!/bin/bash
set -e

function shutdown() {
    # stop smb
    pidof smbd >/dev/null && killall smbd || true
    pidof nmbd >/dev/null && killall nmbd || true
    # stop nfs
    exportfs -ua || true
    exit 0
}

trap shutdown SIGINT SIGTERM

# initialize users
SMBPASSWD_FILE=$(grep -E "^[[:space:]]*passdb backend[[:space:]]*=" /etc/samba/smb.conf | awk -F'=' '{print $2}' | awk -F':' '{print $2}' | tr -d '[:space:]')
if [ -f "$SMBPASSWD_FILE" ]; then
    # Read users from smbpasswd file and create system users
    while IFS=':' read -r username _; do
        if [ ! -z "$username" ] && [[ ! "$username" =~ ^[#].*$ ]]; then
            /usr/sbin/adduser --no-create-home --disabled-password --disabled-login --gecos "" "$username" || true
        fi
    done < "$SMBPASSWD_FILE"
fi

smbd
exportfs -a

sleep infinity
