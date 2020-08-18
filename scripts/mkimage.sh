#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Usage: $0 imgfilename sizeMiB [product]"
	exit -1 ;
fi

outfilename=$1
outsizemb=$2
tmpfile=tmpfile

if [ $# -gt 2 ]; then
	product=$3;
else
	product=nitrogen8m;
fi

if [ -z "$OUT" ]; then OUT=out/target/product/$product; fi
if ! [ -d $OUT ]; then
	echo "Missing $OUT";
	exit 1;
fi

if [ -e "$outfilename" ]; then
	echo "$outfilename already exists... bailing out";
	exit 1;
else
	dd if=/dev/zero bs=1M count=$outsizemb of=$tmpfile;
fi
echo "---------build SD card image $outfilename of size ${outsizemb}MiB for product $product";

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/partitions.inc

sudo parted -a optimal \
	-s ${tmpfile} \
	unit MiB \
	mklabel gpt \
	$MKPART_COMMAND \
	print

setuploop() {
	path=$1;
	partnum=$2;
	parts=`fdisk -l $path | grep ^$path | sed s/$path// | grep ^$partnum | sed 's/\\*//'`;
	starts=`echo $parts | sed 's/*//' | awk '{print $2}'`;
	startb=`expr $starts \* 512`;
	ends=`echo $parts | awk '{print $3}'`;
	endb=`expr \( $ends \+ 1 \) \* 512`;
	sizeb=`expr $endb - $startb`;
	loopdev=`sudo losetup -f`;
	sudo losetup -o $startb --sizelimit $sizeb $loopdev $path
	if [ $? -ne 0 ] ; then
		echo "failed to setup loop for part $partnum"
		exit 1
	fi
	export loopdev;
	echo "$path: $loopdev: $sizeb bytes";
}

flashpart() {
	part_index=$1
	part_img=$OUT/$2
	echo "flashing $part_img to partion #${part_index}..."
	setuploop $tmpfile $part_index
	if [ ! -e $part_img ]; then
		echo "partition $part_img doesn't exist"
		exit 1
	fi
	file $part_img | grep sparse > /dev/null
	if [ $? -eq 0 ] ; then
		sudo simg2img $part_img $loopdev
	else
		sudo dd if=$part_img of=$loopdev bs=1M
	fi
	sync
	sudo losetup -d $loopdev
}

flashpart 1 preboot.img
flashpart 2 dtbo.img
flashpart 3 boot.img
flashpart 4 recovery.img
flashpart 5 system.img
flashpart 6 cache.img
flashpart 10 vendor.img
flashpart 12 vbmeta.img

# trim final image without userdata
dd if=$tmpfile of=$outfilename bs=1M count=$(( $DATA_PART_BEGIN + 1 )) && sync && rm $tmpfile
