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
mkpart system 40 1320 \
mkpart cache 1320 1832 \
mkpart vendor 1832 1896 \
mkpart misc 1896 1900 \
mkpart crypt 1900 1902 \
mkpart frp 1902 1903 \
mkpart metadata 1903 1904 \
mkpart data 1904 100% \
print

dd if=$OUT/image.img of=$OUT/gpt.img count=64
rm -rf $OUT/image.img

echo "$OUT/gpt.img is ready!"
