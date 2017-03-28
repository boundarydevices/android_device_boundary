#!/bin/sh

if [ -z "$PRODUCT" ]; then PRODUCT=nitrogen6x; fi
if [ -z "$OUT" ]; then OUT=out/target/product/$PRODUCT; fi

if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

fastboot -i 0x0525 flash gpt $OUT/gpt.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash gpt.img"; exit 1; fi
fastboot -i 0x0525 flash boot $OUT/boot.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash boot.img"; exit 1; fi
fastboot -i 0x0525 flash recovery $OUT/recovery.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash recovery.img"; exit 1; fi
fastboot -i 0x0525 flash system $OUT/system.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash system.img"; exit 1; fi
fastboot -i 0x0525 flash cache $OUT/cache.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash cache.img"; exit 1; fi
fastboot -i 0x0525 flash vendor $OUT/vendor.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash vendor.img"; exit 1; fi
fastboot -i 0x0525 flash data $OUT/userdata.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash userdata.img"; exit 1; fi
fastboot -i 0x0525 continue
