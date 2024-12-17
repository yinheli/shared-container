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

smbd
exportfs -a

sleep infinity
