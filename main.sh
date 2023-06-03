#!/usr/bin/env bash

usage() {
    echo "usage: yumei-chroot <where-to-chroot>"
}

if [[ "$1" == "" || "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
    usage
    exit 0
fi

ROOT="$1"

mount --bind /dev $ROOT/dev
mount --bind /dev/pts $ROOT/dev/pts
mount -t proc proc $ROOT/proc
mount -t sysfs sysfs $ROOT/sys
mount -t tmpfs tmpfs $ROOT/run

if [ -h $ROOT/dev/shm ]; then
    mkdir -pv $ROOT/$(readlink $ROOT/dev/shm)
else
    mount -t tmpfs -o nosuid,nodev tmpfs $ROOT/dev/shm
fi

chroot "$ROOT" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(yumei-chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /bin/bash --login