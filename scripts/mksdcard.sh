#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 /dev/diskname [product=nitrogen6x]"
	exit -1 ;
fi

if [ $# -ge 2 ]; then
	product=$2;
else
	product=nitrogen6x;
fi

echo "---------build SD card for product $product";

if [ -z "$OUT" ]; then OUT=out/target/product/$product; fi
if ! [ -d $OUT ]; then
	echo "Missing $OUT";
	exit 1;
fi

diskname=$1
prefix='';

if [[ "$diskname" =~ "mmcblk" ]]; then
	prefix=p
fi

umount ${diskname}${prefix}*

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/partitions.inc

sudo parted -a optimal \
	-s ${diskname} \
	unit MiB \
	mklabel gpt \
	$MKPART_COMMAND \
	print

sudo partprobe && sleep 1

flashpart() {
	part_index=$1
	part_img=$OUT/$2
	diskpart=${diskname}${prefix}${part_index}
	echo "flashing $part_img to partion #${part_index}..."
	if [ ! -e $part_img ]; then
		echo "image $part_img doesn't exist"
		exit 1
	fi
	if [ ! -e ${diskpart} ]; then
		echo "partition ${diskpart} doesn't exist"
		exit 1
	fi
	file $part_img | grep sparse > /dev/null
	if [ $? -eq 0 ] ; then
		sudo simg2img $part_img $diskpart
	else
		sudo dd if=$part_img of=$diskpart bs=1M
	fi
	sync
}

flashpart 1 boot.img
flashpart 2 recovery.img
flashpart 3 system.img
flashpart 4 cache.img
flashpart 5 vendor.img

# Format userdata partition
sudo mkfs.ext4 ${diskname}${prefix}10

sync
echo "---------done! SD card is ready!";
