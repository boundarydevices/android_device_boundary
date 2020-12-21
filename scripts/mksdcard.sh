#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 /dev/diskname [product=nitrogen6x] [--force]"
	exit -1 ;
fi

if ! hash udisks 2> /dev/null; then
	if ! hash udisksctl 2> /dev/null; then
		echo "This script requires udisks or udisks2 to be installed"
		exit -1
	else
		mount="udisksctl mount -b";
		mountpoint="/media/$USER";
	fi
else
	mount="udisks --mount";
	mountpoint="/media";
fi

force='';
if [ $# -ge 2 ]; then
   product=$2;
   if [ $# -ge 3 ]; then
      if [ "x--force" == "x$3" ]; then
         force=yes;
      fi
   fi
else
   product=nitrogen6x;
fi

echo "---------build SD card for product $product";

if ! [ -d out/target/product/$product/data ]; then
   echo "Missing out/target/product/$product";
   exit 1;
fi

removable_disks() {
	for f in `ls /dev/disk/by-path/* | grep -v part` ; do
		diskname=$(basename `readlink $f`);
		type=`cat /sys/class/block/$diskname/device/type` ;
		size=`cat /sys/class/block/$diskname/size` ;
		issd=0 ;
		if [ $size -ge 3906250 ]; then
			if [ $size -lt 62500000 ]; then
				issd=1 ;
			fi
		fi
		if [ "$issd" -eq "1" ]; then
			echo -n "/dev/$diskname ";
		fi
	done
	echo;
}
diskname=$1
removables=`removable_disks`

for disk in $removables ; do
   echo "removable disk $disk" ;
   if [ "$diskname" = "$disk" ]; then
      matched=1 ;
      break ;
   fi
done

if [ -z "$matched" -a -z "$force" ]; then
   echo "Invalid disk $diskname" ;
   exit -1;
fi

prefix='';

if [[ "$diskname" =~ "mmcblk" ]]; then
   prefix=p
fi

echo "reasonable disk $diskname, partitions ${diskname}${prefix}1..." ;
umount ${diskname}${prefix}*

dd if=/dev/zero of=${diskname} count=1 bs=1024

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/partitions.inc

sudo parted -a optimal \
-s ${diskname} \
unit MiB \
mklabel gpt \
$MKPART_COMMAND \
print

sudo partprobe && sleep 1

for n in `seq 1 8` ; do
   if ! [ -e ${diskname}${prefix}$n ] ; then
      echo "--------------missing ${diskname}${prefix}$n" ;
      exit 1;
   fi
   sync
done

echo "all partitions present and accounted for!";

echo "------------------making boot partition"
mkfs.ext4 -F -L boot ${diskname}${prefix}1
echo "------------------making recovery partition"
mkfs.ext4 -F -L recovery ${diskname}${prefix}2
echo "------------------making data partition"
mkfs.ext4 -F -L data ${diskname}${prefix}10
echo "------------------making cache partition"
mkfs.ext4 -F -L cache ${diskname}${prefix}4
echo "------------------making vendor partition"
mkfs.ext4 -F -L vendor ${diskname}${prefix}5

echo "------------------mounting boot, recovery, data partitions"
sync && sudo partprobe && sleep 5

for n in 1 2 5 10 ; do
   echo "--- mounting ${diskname}${prefix}${n}";
   ${mount} ${diskname}${prefix}${n}
done

sudo cp -rfv out/target/product/$product/boot/* ${mountpoint}/boot/
sudo cp -rfv out/target/product/$product/boot/* ${mountpoint}/recovery/
sudo cp -rfv out/target/product/$product/uramdisk-recovery.img ${mountpoint}/recovery/uramdisk.img
sudo cp -rfv out/target/product/$product/data/* ${mountpoint}/data/
sudo cp -rfv out/target/product/$product/vendor/* ${mountpoint}/vendor/

if [ -e ${diskname}${prefix}3 ]; then
   # Check whether system image is sparse or not
   system_img=out/target/product/$product/system.img
   file $system_img | grep sparse > /dev/null
   if [ $? -eq 0 ] ; then
      sudo ./out/host/linux-x86/bin/simg2img $system_img ${diskname}${prefix}3
   else
      sudo dd if=$system_img of=${diskname}${prefix}3 bs=1M
   fi
   sudo e2fsck -f ${diskname}${prefix}3
else
   echo "-----------missing ${diskname}${prefix}3";
fi

sync && sudo umount ${diskname}${prefix}*

