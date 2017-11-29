#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Usage: $0 imgfilename sizeMiB [product=nitrogen6x]"
	exit -1 ;
fi

outfilename=$1
outsizemb=$2

if [ $# -gt 2 ]; then
   product=$3;
else
   product=nitrogen6x;
fi

if ! [ -d out/target/product/$product/system ]; then
   echo "Missing out/target/product/$product/system";
   exit 1;
fi

if [ -e "$outfilename" ]; then
   echo "$outfilename already exists... bailing out";
   # exit 1;
else
   echo "---------build SD card image $outfilename of size ${outsizemb}MiB for product $product";
   dd if=/dev/zero bs=1M count=$outsizemb of=$outfilename
fi

#
# Turkey carving (in MiB):
#
# [0     4)          4     partition table, optionally U-Boot
# [4     24)      1  20    Boot partition
# [24    44)      2  20    Recovery partition
# [44    1120)    3  1072  extended
# [48    560)     5  512   system partition
# [564   1076)    6  512   cache partition
# [1080  1096)    7  16    vendor partition   
# [1100  1116)    8  16    misc partition
# [1120  outsize) 9  ---   data partition
#
BOOTSTART=4
BOOTEND=24
RECOVERSTART=$BOOTEND
RECOVEREND=44
EXTSTART=$RECOVEREND
EXTEND=1120
SYSTEMSTART=48
SYSTEMEND=560
CACHESTART=564
CACHEEND=1076
VENDSTART=1080
VENDEND=1096
MISCSTART=1100
MISCEND=1116
DATASTART=1120
DATAEND=`expr $outsizemb - 4`
parted $outfilename mklabel msdos
parted $outfilename unit MiB mkpart primary fat32 $BOOTSTART $BOOTEND
parted $outfilename unit MiB mkpart primary fat32 $RECOVERSTART $RECOVEREND
parted $outfilename unit MiB mkpart extended $EXTSTART $EXTEND
parted $outfilename unit MiB mkpart logical ext2 $SYSTEMSTART $SYSTEMEND
parted $outfilename unit MiB mkpart logical ext2 $CACHESTART $CACHEEND
parted $outfilename unit MiB mkpart logical ext2 $VENDSTART $VENDEND
parted $outfilename unit MiB mkpart logical ext2 $MISCSTART $MISCEND
parted $outfilename unit MiB mkpart primary ext2 $DATASTART $DATAEND
parted $outfilename unit MiB print

setuploop(){
      path=$1;
      partnum=$2;
      start=$3;
      end=$4;
      parts=`fdisk -l $path | grep ^$path | sed s/$path// | grep ^$partnum` ;
      startb=`expr $start \* 1024 \* 1024`;
      #starts=`echo $parts | awk '{print $2}'`;
      #startb2=`expr $starts \* 512`;
      #echo "$path: start $startb $startb2"
      #endb=`expr $end \* 1024 \* 1024`;
      #ends=`echo $parts | awk '{print $3}'`;
      #endb2=`expr \( $ends \+ 1 \) \* 512`;
      #echo "$path: end $endb $endb2"
      sizeb=`expr \( $end - $start \) \* 1024 \* 1024`;
      #echo "$path: size $sizeb";
      loopdev=`sudo losetup -f`;
      sudo losetup -o $startb --sizelimit $sizeb $loopdev $path
      export loopdev;
      echo "$path: $loopdev: $sizeb bytes";
}

setuploop $outfilename 1 $BOOTSTART $BOOTEND   
sudo mkfs.vfat -n BOOT $loopdev
sleep 1
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ "$mountpoint" == "" ]; then
	echo "error mountpoint not found"
	exit 1
fi
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/boot/* $mountpoint/
fi
sudo umount $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 2 $RECOVERSTART $RECOVEREND   
sudo mkfs.vfat -n RECOVER $loopdev
sleep 1
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ "$mountpoint" == "" ]; then
	echo "error mountpoint not found"
	exit 1
fi
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/boot/* $mountpoint/
   sudo cp -rfv out/target/product/$product/uramdisk-recovery.img $mountpoint/uramdisk.img
fi
sudo umount $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 4 $DATASTART $DATAEND   
sudo mkfs.ext4 -L DATA $loopdev
sleep 1
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ "$mountpoint" == "" ]; then
	echo "error mountpoint not found"
	exit 1
fi
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/data/* $mountpoint/
fi
sudo umount $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 5 $SYSTEMSTART $SYSTEMEND
e2label out/target/product/$product/system.img
sudo dd if=out/target/product/$product/system.img of=$loopdev
sudo e2label $loopdev SYSTEM
sudo e2fsck -f $loopdev
sudo resize2fs $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 6 $CACHESTART $CACHEEND   
sudo mkfs.ext4 -L CACHE $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 7 $VENDSTART $VENDEND   
sudo mkfs.ext4 -L VENDOR $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 8 $MISCSTART $MISCEND
sudo mkfs.ext4 -L MISC $loopdev
sudo losetup -d $loopdev

