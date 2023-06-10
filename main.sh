#!/usr/bin/env bash

usage() {
    echo "usage: yumei-chroot <where-to-chroot>"
}

if [[ "$1" == "" || "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
    usage
    exit 0
fi

ROOT="$1"

mkdir -p $ROOT/{dev,proc,sys,run}
mount --types proc /proc $ROOT/proc
mount --rbind /sys $ROOT/sys
mount --make-rslave $ROOT/sys
mount --rbind /dev $ROOT/dev
mount --make-rslave $ROOT/dev
mount --bind /run $ROOT/run
mount --make-slave $ROOT/run

chroot "$ROOT" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(yumei-chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /bin/bash --login

umount $ROOT/dev/pts
mountpoint -q $ROOT/dev/shm && umount $ROOT/dev/shm
umount $ROOT/{dev,run,proc,sys}