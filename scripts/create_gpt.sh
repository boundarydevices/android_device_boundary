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
mkpart boot 2 34 \
mkpart recovery 34 66 \
mkpart system 66 1346 \
mkpart cache 1346 1858 \
mkpart vendor 1858 1922 \
mkpart misc 1922 1924 \
mkpart crypt 1924 1926 \
mkpart frp 1926 1927 \
mkpart metadata 1927 1928 \
mkpart data 1928 100% \
print

dd if=$OUT/image.img of=$OUT/gpt.img count=64
rm -rf $OUT/image.img

echo "$OUT/gpt.img is ready!"
