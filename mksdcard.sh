#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 /dev/diskname [product=nitrogen6x]"
	exit -1 ;
fi

if [ $# -ge 2 ]; then
   product=$2;
else
   product=nitrogen6x;
fi

echo "---------build SD card for product $product";

if ! [ -d out/target/product/$product/data ]; then
   echo "Missing out/target/product/$product";
   exit 1;
fi

removable_disks() {
	for f in `ls /dev/disk/by-path/* | grep -v part` ; do
		diskname=$(basename `readlink $f`);
		type=`cat /sys/class/block/$diskname/device/type` ;
		size=`cat /sys/class/block/$diskname/size` ;
		issd=0 ;
		# echo "checking $diskname/$type/$size" ;
		if [ $size -ge 3906250 ]; then
			if [ $size -lt 62500000 ]; then
				issd=1 ;
			fi
		fi
		if [ "$issd" -eq "1" ]; then
			echo -n "/dev/$diskname ";
			# echo "removable disk /dev/$diskname, size $size, type $type" ;
			#echo -n -e "\tremovable? " ; cat /sys/class/block/$diskname/removable ;
		fi
	done
	echo;
}
diskname=$1
removables=`removable_disks`

for disk in $removables ; do
   echo "removable disk $disk" ;
   if [ "$diskname" = "$disk" ]; then
      matched=1 ;
      break ;
   fi
done

if [ -z "$matched" ]; then
   echo "Invalid disk $diskname" ;
   exit -1;
fi

prefix='';

if [[ "$diskname" =~ "mmcblk" ]]; then
   prefix=p
fi

echo "reasonable disk $diskname, partitions ${diskname}${prefix}1..." ;
umount ${diskname}${prefix}*
umount gvfs

sfdisk -uM ${diskname} << EOF
,20,B,*
,20,B
,2048,E
,,B
,512,83
,256,83
,1024,83
,10,83
,10,83
EOF

mkfs.vfat -n BOOT ${diskname}${prefix}1
mkfs.vfat -n RECOVER ${diskname}${prefix}2
mkfs.vfat -n MEDIA ${diskname}${prefix}4
mkfs.ext4 -L SYSTEM ${diskname}${prefix}5
mkfs.ext4 -L CACHE ${diskname}${prefix}6
mkfs.ext4 -L DATA ${diskname}${prefix}7
mkfs.ext4 -L VENDOR ${diskname}${prefix}8
mkfs.ext4 -L MISC ${diskname}${prefix}9

for n in 1 2 5 7 ; do
   udisks --mount ${diskname}${prefix}${n}
done

sudo cp -rafv out/target/product/$product/boot/* /media/BOOT/
sudo cp -rafv out/target/product/$product/boot/6x* /media/RECOVER/
sudo cp -rafv out/target/product/$product/boot/uImage /media/RECOVER/
sudo cp -rafv out/target/product/$product/uramdisk-recovery.img /media/RECOVER/uramdisk.img
sudo cp -ravf out/target/product/$product/system/* /media/SYSTEM/
sudo cp -ravf out/target/product/$product/data/* /media/DATA/
sync && sudo umount ${diskname}${prefix}*

