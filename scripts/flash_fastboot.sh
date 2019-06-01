#!/bin/sh

if [ "$#" -ne 1 ]; then
   echo "Missing board name!";
   exit 1;
fi

case "$1" in
	nitrogen8m)
		PRODUCT=nitrogen8m
	;;
	nitrogen8mm)
		PRODUCT=nitrogen8mm
	;;
	*)
		echo "Board name wrong!";
   		exit 1;
	;;
esac

if [ -z "$OUT" ]; then OUT=../../../out/target/product/$PRODUCT; fi

if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

fastboot flash gpt $OUT/partition-table.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash gpt.img"; exit 1; fi
fastboot flash boot $OUT/boot.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash boot.img"; exit 1; fi
fastboot flash recovery $OUT/recovery.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash recovery.img"; exit 1; fi
fastboot flash system $OUT/system.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash system.img"; exit 1; fi
fastboot flash cache $OUT/cache.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash cache.img"; exit 1; fi
fastboot flash vendor $OUT/vendor.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash vendor.img"; exit 1; fi
fastboot flash userdata $OUT/userdata.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash userdata.img"; exit 1; fi
fastboot continue
