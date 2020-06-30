#!/bin/sh

if [ -z "$PRODUCT" ]; then PRODUCT=nitrogen6x; fi
if [ -z "$OUT" ]; then OUT=out/target/product/$PRODUCT; fi

if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

OPT="-i 0x0525"
fastboot $OPT devices | grep fastboot > /dev/null
if ! [ $? -eq 0 ] ; then OPT="-i 0x3016"; fi
fastboot $OPT devices | grep fastboot > /dev/null
if ! [ $? -eq 0 ] ; then OPT=""; fi

fastboot $OPT flash gpt $OUT/gpt.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash gpt.img"; exit 1; fi
fastboot $OPT flash boot $OUT/boot.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash boot.img"; exit 1; fi
fastboot $OPT flash recovery $OUT/recovery.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash recovery.img"; exit 1; fi
fastboot $OPT flash system $OUT/system.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash system.img"; exit 1; fi
fastboot $OPT flash cache $OUT/cache.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash cache.img"; exit 1; fi
fastboot $OPT flash vendor $OUT/vendor.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash vendor.img"; exit 1; fi
fastboot $OPT erase data
if ! [ $? -eq 0 ] ; then echo "Failed to erase data"; exit 1; fi
fastboot $OPT continue
