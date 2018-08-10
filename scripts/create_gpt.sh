#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Usage: $0 sizeMiB"
	exit -1 ;
fi

if [ -z "$PRODUCT" ]; then PRODUCT=nitrogen6x; fi
if [ -z "$OUT" ]; then OUT=out/target/product/$PRODUCT; fi

if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

sizeMB=$1

dd if=/dev/zero of=$OUT/image.img bs=1 count=0 seek=${sizeMB}M

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/partitions.inc

parted -a optimal -s $OUT/image.img \
unit MiB \
mklabel gpt \
$MKPART_COMMAND \
print

dd if=$OUT/image.img of=$OUT/gpt.img count=64
rm -rf $OUT/image.img

echo "$OUT/gpt.img is ready!"
