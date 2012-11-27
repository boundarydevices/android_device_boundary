#!/bin/sh
sfdisk -uM /dev/sdc << EOF
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

mkfs.vfat -n BOOT /dev/sdc1
mkfs.vfat -n RECOVERY /dev/sdc2
mkfs.vfat -n MEDIA /dev/sdc4
mkfs.ext4 -L SYSTEM /dev/sdc5
mkfs.ext4 -L CACHE /dev/sdc6
mkfs.ext4 -L DATA /dev/sdc7
mkfs.ext4 -L VENDOR /dev/sdc8
mkfs.ext4 -L MISC /dev/sdc9

echo -n "remove and re-insert SD card here"
read line

cp -fv kernel_imx/arch/arm/boot/uImage /media/BOOT/
mkdir out/target/product/nitrogen6x/boot
~/bin/make_initramfs out/target/product/nitrogen6x/root uramdisk.img
cp -fv uramdisk.img /media/BOOT
cp -fv bootable/bootloader/uboot_imx/u-boot.imx /media/BOOT/
... copy 6x_android_bootscript to /media/BOOT
sync && sudo umount /media/BOOT/

cp -ravf out/target/product/nitrogen6x/system/* /media/SYSTEM/
cp -ravf out/target/product/nitrogen6x/data/* /media/DATA/



