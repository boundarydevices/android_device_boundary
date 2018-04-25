#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Usage: $0 imgfilename sizeMiB [product=nitrogen6x]"
	exit -1 ;
fi

if ! hash udisks 2> /dev/null; then
	if ! hash udisksctl 2> /dev/null; then
		echo "This script requires udisks or udisks2 to be installed"
		exit -1
	else
		mount="udisksctl mount -b";
	fi
else
	mount="udisks --mount";
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

sudo parted -a minimal \
-s ${outfilename} \
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

setuploop(){
      path=$1;
      partnum=$2;
      parts=`fdisk -l $path | grep ^$path | sed s/$path// | grep ^$partnum | sed 's/\\*//'`;
      starts=`echo $parts | sed 's/*//' | awk '{print $2}'`;
      startb=`expr $starts \* 512`;
      ends=`echo $parts | awk '{print $3}'`;
      endb=`expr \( $ends \+ 1 \) \* 512`;
      sizeb=`expr $endb - $startb`;
      loopdev=`sudo losetup -f`;
      sudo losetup -o $startb --sizelimit $sizeb $loopdev $path
      export loopdev;
      echo "$path: $loopdev: $sizeb bytes";
}

setuploop $outfilename 1
sudo mkfs.ext4 -L boot $loopdev
$mount $loopdev
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

setuploop $outfilename 2
sudo mkfs.ext4 -L recovery $loopdev
$mount $loopdev
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

setuploop $outfilename 10
sudo mkfs.ext4 -L data $loopdev
$mount $loopdev
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

setuploop $outfilename 3
# Check whether system image is sparse or not
system_img=out/target/product/$product/system.img
file $system_img | grep sparse > /dev/null
if [ $? -eq 0 ] ; then
   sudo ./out/host/linux-x86/bin/simg2img $system_img $loopdev
else
   sudo dd if=$system_img of=$loopdev bs=1M
fi
sudo e2fsck -f $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 4
sudo mkfs.ext4 -L cache $loopdev
sudo losetup -d $loopdev

setuploop $outfilename 5
sudo mkfs.ext4 -L vendor $loopdev
$mount $loopdev
mountpoint=`mount | grep $loopdev | awk '{ print $3 }'`;
if [ "$mountpoint" == "" ]; then
	echo "error mountpoint not found"
	exit 1
fi
if [ -d $mountpoint ]; then
   sudo cp -rvf out/target/product/$product/vendor/* $mountpoint/
fi
sudo umount $loopdev
sudo losetup -d $loopdev

