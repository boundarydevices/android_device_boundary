#!/bin/sh

if [ -z "$PRODUCT" ]; then PRODUCT=nitrogen8m; fi
if [ -z "$OUT" ]; then OUT=out/target/product/$PRODUCT; fi

if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

fastboot flash gpt $OUT/partition-table.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash gpt.img"; exit 1; fi
fastboot flash preboot $OUT/preboot.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash preboot.img"; exit 1; fi
fastboot flash dtbo $OUT/dtbo.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash dtbo.img"; exit 1; fi
fastboot flash boot $OUT/boot.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash boot.img"; exit 1; fi
fastboot flash recovery $OUT/recovery.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash recovery.img"; exit 1; fi
fastboot flash system $OUT/system.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash system.img"; exit 1; fi
fastboot flash vendor $OUT/vendor.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash vendor.img"; exit 1; fi
fastboot flash vbmeta $OUT/vbmeta.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash vbmeta.img"; exit 1; fi
fastboot flash cache $OUT/cache.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash cache.img"; exit 1; fi
if ! [ "$1" = "-d" ] ; then
	echo fastboot erase userdata
	if ! [ $? -eq 0 ] ; then echo "Failed to erase userdata"; exit 1; fi
fi
fastboot continue
