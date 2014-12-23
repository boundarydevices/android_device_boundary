#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Usage: $0 outfilename sizeMiB [product=nitrogen6x]"
	exit -1 ;
fi

outfilename=$1
outfilesize=$2

if [ "$outfilesize" -lt "2188" ] ; then
   echo "Invalid sizeMB $outfilesize... must be >= 2188";
   exit 1;
fi

if [ "$outfilesize" -gt "131072" ] ; then
   echo "Invalid sizeMB $outfilesize... must be <= 128 GiB";
   exit 1;
fi

for arg in $* ; do 
   echo "$arg" ;
done

force='';
if [ $# -ge 3 ]; then
   product=$3;
else
   product=nitrogen6x;
fi

if ! [ -d out/target/product/$product/data ]; then
   echo "Missing out/target/product/$product";
#   exit 1;
fi

if [ -e "$outfilename" ]; then
      echo "Cowardly refusing to overwrite $outfilename";
      exit 1;
fi

echo "---------build SD card image $outfilename for product $product, size $outfilesize MiB";
echo "-------- create blank image";
dd if=/dev/zero of=${outfilename} count=$outfilesize bs=1M

echo "-------- create partitions";
parted -s ${outfilename} mklabel msdos
parted -s ${outfilename} mkpart primary fat32 4MiB 24MiB
parted -s ${outfilename} set 1 boot on
parted -s ${outfilename} mkpart primary fat32 24MiB 44MiB
parted -s ${outfilename} mkpart extended 44MiB 2GiB
parted -s ${outfilename} mkpart primary ext4 2GiB 3600MiB
parted -s ${outfilename} mkpart logical ext4 48MiB 564MiB
parted -s ${outfilename} mkpart logical ext4 572MiB 1088MiB
parted -s ${outfilename} mkpart logical ext4 1096MiB 1116MiB
parted -s ${outfilename} mkpart logical ext4 1120MiB 1152MiB

do_format(){
    imgfile=$1;
    partnum=$2;
    type=$3;
    partname=$4;
    copyfrom=$5;
    echo "------------------making ${partname} partition on p$partnum, type $type, source $copyfrom";
    partline=`parted -s $imgfile unit B print | grep "^ $partnum"`;
    echo "partition line: $partline";
    start=`echo $partline | awk '{print $2}' | sed 's/B//'`;
    end=`echo $partline | awk '{print $3}' | sed 's/B//'`;
    size=`echo $partline | awk '{print $4}' | sed 's/B//'`;
    loopdev=`losetup -f`;
    echo losetup -o $start --sizelimit $size $loopdev $imgfile;
    sudo losetup -o $start --sizelimit $size $loopdev $imgfile;
    if [ "xvfat" == "x$type" ] ; then
        labelparam="-n $partname";
    else
        labelparam="-L $partname";
    fi
    sudo mkfs.$type $labelparam $loopdev;
    if [ -d "$copyfrom" ]; then
        echo "------- copy directory from $copyfrom";
	target_dir=`udisks --mount $loopdev | awk '{print $4}'`;
	if [ -d "$target_dir" ]; then
		cp -ravf $copyfrom/* $target_dir/;
	else
		echo "Error mounting loopdev for $copyfrom";
	fi
	sudo umount $loopdev;
    elif [ -f "$copyfrom" ]; then
        echo "------- copy image file from $copyfrom";
        dd if=$copyfrom of=$loopdev bs=1M;
    else
        echo "------- no source directory or file specified";
    fi
    sudo losetup -d $loopdev;
};

do_format $outfilename 1 vfat BOOT out/target/product/$product/boot
do_format $outfilename 2 vfat RECOVER out/target/product/$product/boot
do_format $outfilename 5 ext4 SYSTEM out/target/product/$product/system.img
do_format $outfilename 4 ext4 DATA out/target/product/$product/data
do_format $outfilename 6 ext4 CACHE
do_format $outfilename 7 ext4 VENDOR
do_format $outfilename 8 ext4 MISC


partline=`parted -s $outfilename unit B print | grep "^ 2"`;
start=`echo $partline | awk '{print $2}' | sed 's/B//'`;
end=`echo $partline | awk '{print $3}' | sed 's/B//'`;
size=`echo $partline | awk '{print $4}' | sed 's/B//'`;
loopdev=`losetup -f`;
echo losetup -o $start --sizelimit $size $loopdev $outfilename;
sudo losetup -o $start --sizelimit $size $loopdev $outfilename;
target_dir=`udisks --mount $loopdev | awk '{print $4}'`;
cp -fv out/target/product/$product/uramdisk-recovery.img $target_dir/uramdisk.img
sudo umount $target_dir
sudo losetup -d $loopdev;

gzip $outfilename

