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
# [0     20)      1  20    Boot partition
# [20    40)      2  20    Recovery partition
# [40    40)      3  0     Stub/Legacy partition
# [40    552)     5  512   System partition
# [552   1064)    6  512   Cache partition
# [1064  1074)    7  10    Vendor partition
# [1074  1084)    8  10    Misc partition
# [1084  outsize) 4  ---   Data partition
#
sudo parted -a minimal \
-s ${diskname} \
unit MiB \
mklabel gpt \
mkpart boot 0% 20 \
mkpart recovery 20 40 \
mkpart extended 40 40 \
mkpart data 1084 100% \
mkpart system 40.1 552 \
mkpart cache 552 1064 \
mkpart vendor 1064 1074 \
mkpart misc 1074 1084 \
print

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
sudo mkfs.ext4 -L BOOT $loopdev
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/boot/* $mountpoint/
fi
sudo umount $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 2 $RECOVERSTART $RECOVEREND   
sudo mkfs.ext4 -L RECOVER $loopdev
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/boot/* $mountpoint/
   sudo cp -rfv out/target/product/$product/uramdisk-recovery.img $mountpoint/uramdisk.img
fi
sudo umount $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 4 $DATASTART $DATAEND   
sudo mkfs.ext4 -L DATA $loopdev
udisks --mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
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

