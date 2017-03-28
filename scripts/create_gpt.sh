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

parted -a minimal -s $OUT/image.img \
unit MiB \
mklabel gpt \
mkpart boot 0% 20 \
mkpart recovery 20 40 \
mkpart extended 40 42 \
mkpart data 1600 100% \
mkpart system 42 1066 \
mkpart cache 1066 1578 \
mkpart vendor 1578 1588 \
mkpart misc 1588 1598 \
mkpart crypt 1598 1600 \
print

dd if=$OUT/image.img of=$OUT/gpt.img count=64
rm -rf $OUT/image.img

echo "$OUT/gpt.img is ready!"
