#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 /dev/diskname [product]"
	exit -1 ;
fi

diskname=$1

if [ $# -ge 2 ]; then
	product=$2;
else
	product=nitrogen8m;
fi

if [ -z "$OUT" ]; then OUT=out/target/product/$product; fi
if ! [ -d $OUT ]; then
	echo "Missing $OUT";
	exit 1;
fi

if [ ! -e "$diskname" ]; then
	echo "Invalid disk $diskname";
	exit -1;
fi
sudo umount ${diskname}*

echo "---------build SD card for product $product";

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/partitions.inc

prefix='';
if [[ "$diskname" =~ "mmcblk" ]]; then
	prefix=p
fi

sudo parted -a optimal \
	-s ${diskname} \
	unit MiB \
	mklabel gpt \
	$MKPART_COMMAND \
	print

sudo partprobe && sleep 1

for n in `seq 1 13` ; do
	if ! [ -e ${diskname}${prefix}$n ] ; then
		echo "--------------missing ${diskname}${prefix}$n" ;
		exit 1;
	fi
	sync
done

flashpart() {
	part_index=$1
	part_img=$OUT/$2
	echo "flashing $part_img to ${diskname}${prefix}${part_index}..."
	file $part_img | grep sparse > /dev/null
	if [ $? -eq 0 ] ; then
		sudo simg2img $part_img ${diskname}${prefix}${part_index}
	else
		sudo dd if=$part_img of=${diskname}${prefix}${part_index} bs=1M
	fi
	sync
}

flashpart 1 preboot.img
flashpart 2 dtbo.img
flashpart 3 boot.img
flashpart 4 recovery.img
flashpart 5 system.img
flashpart 6 cache.img
flashpart 10 vendor.img
flashpart 12 vbmeta.img
