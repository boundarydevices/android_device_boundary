#!/bin/bash

# Partition sizes in MiB
BOOT_SIZE=48
RECOVERY_SIZE=48
SYSTEM_SIZE=1792
CACHE_SIZE=512
MISC_SIZE=4
DATAFOLDER_SIZE=2
METADATA_SIZE=2
PRESISTDATA_SIZE=1
VENDOR_SIZE=112
FBMISC_SIZE=1

node="na"
board_name="na"
moreoptions=1

while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
    case $1 in
        -d) node=$2; shift;;
		-b) board_name=$2; shift;;
		*)  moreoptions=0;;
    esac
    [ "$moreoptions" = 0 ] && [ $# -gt 1 ] && exit
    [ "$moreoptions" = 1 ] && shift
done


outdir="../../../out/target/product/$board_name"

disk_size=`sfdisk -s ${node}`
disk_size=`expr ${disk_size} \/ 1024`
userdata_size=`expr ${disk_size} - 8 - ${RECOVERY_SIZE} - ${BOOT_SIZE} - ${SYSTEM_SIZE} - ${CACHE_SIZE} - ${MISC_SIZE} - ${DATAFOLDER_SIZE} - ${METADATA_SIZE} - ${PRESISTDATA_SIZE} - ${VENDOR_SIZE} - ${FBMISC_SIZE}`


umount ${node}*  2> /dev/null || true

for partition in ${node}*
do
	if [[ ${partition} = ${node} ]] ; then
		# skip base node
		continue
	fi
	dd if=/dev/zero of=${partition} bs=1M count=1 2> /dev/null || true
done
sync

sgdisk -Z $node
sync

dd if=/dev/zero of=$node bs=1M count=8
sync; sleep 1

sgdisk -n 1:8M:+${BOOT_SIZE}M                   -c 1:"boot"          $node
sgdisk -n 2:0:+${RECOVERY_SIZE}M                -c 2:"recovery"      $node
sgdisk -n 3:0:+${SYSTEM_SIZE}M                  -c 3:"system"       $node
sgdisk -n 4:0:+${CACHE_SIZE}M                   -c 4:"cache"        $node
sgdisk -n 5:0:+${MISC_SIZE}M                    -c 5:"misc"          $node
sgdisk -n 6:0:+${DATAFOLDER_SIZE}M              -c 6:"datafolder"   $node
sgdisk -n 7:0:+${METADATA_SIZE}M                -c 7:"metadata"     $node
sgdisk -n 8:0:+${PRESISTDATA_SIZE}M             -c 8:"persistdata"   $node
sgdisk -n 9:0:+${VENDOR_SIZE}M                  -c 9:"vendor"        $node
sgdisk -n 10:0:+${FBMISC_SIZE}M                 -c 10:"fbmisc"       $node
sgdisk -n 11:0:+${userdata_size}M               -c 11:"userdata"    $node

sync;

for i in `cat /proc/mounts | grep "${node}" | awk '{print $2}'`; do umount $i; done
hdparm -z $node
sync; sleep 3

# backup the GPT table to last LBA.
echo -e 'r\ne\nY\nw\nY\nY' |  gdisk $node
sync;
sgdisk -p $node


dd if=/dev/zero of=${node}8 bs=1M count=${PRESISTDATA_SIZE} conv=fsync
dd if=/dev/zero of=${node}10 bs=1M count=${FBMISC_SIZE} conv=fsync
dd if=/dev/zero of=${node}5 bs=1M count=${MISC_SIZE} conv=fsync
dd if=/dev/zero of=${node}6 bs=1M count=${DATAFOLDER_SIZE} conv=fsync
dd if=/dev/zero of=${node}7 bs=1M count=${METADATA_SIZE} conv=fsync
mkfs.ext4 -F ${node}11 -Ldata
sync;

simg2img ${outdir}/boot.img ${node}1
simg2img ${outdir}/recovery.img ${node}2
simg2img ${outdir}/system.img ${node}3
simg2img ${outdir}/cache.img ${node}4
simg2img ${outdir}/vendor.img ${node}9
sync;
