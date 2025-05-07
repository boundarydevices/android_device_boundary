#!/bin/bash

# Below steps show how to change the file in ramdisk in bootimage
# * unzip the bootimage
#   ./unpack_bootimg --boot_img gki_boot.img --out unpack_out
# * unzip ramdisk.
#   if the bootimage is GKI bootimage, the ramdisk type is lz4:
#   lz4 -d ../unpack_out/ramdisk | cpio -imd
#   if the bootimage is nxp bootimage, the ramdisk type is gunzip:
#   gunzip -c boot.img-ramdisk.gz | cpio -i
# * change file in ramdisk
# * pack the ramdisk file
#   gzip: "find . ! -name . | LC_ALL=C sort | cpio -o -H newc -R root:root | gzip > ../new-boot.img-ramdisk.gz"
#   lz4: "find . ! -name . | LC_ALL=C sort | cpio -o -H newc -R root:root | lz4 > ../new-boot.img-ramdisk.lz4"
# * add below patch in replace_kernel.sh
#    +cp  /home/sanshan/imx_android-11.0/new-boot.img-ramdisk.gz ${unpack_out_dir}/ramdisk
#	 echo "Replace ${Image} in ${boot_img} ..."
# * generate new bootimage which include new ramdisk
#   ./device/nxp/common/tools/replace_kernel.sh -b gki_boot.img -i ~/Image -o only_replace_new_ramdisk_boot.img
#

BOARD_KERNEL_OFFSET=0x00080000
help()
{
    echo "Usage: Using Image to replace old one in boot.img, then generate new_boot.img"
    echo "       $0 -b boot.img -i Image -o new_boot.img [-r ramdisk]"
    echo "           boot.img    : old android boot image"
    echo "           Image       : new kernel Image"
    echo "           new_boot.img: new android boot image"
    echo "           ramdisk     : new ramdisk [optional]"
    echo " "
    echo "       Note:"
    echo "           This script depends on two binaries: unpack_bootimg and mkbootimg."
    echo "           Both of them are built from ANDROID source code: mmm system/tools/mkbootimg."
    echo "           Then copy them from out/host/linux/bin to current directory."
}

if [ $# -lt 6 ]; then
    help
    exit 1;
fi

new_ramdisk=0
while getopts 'b:i:o:r:h' OPTION; do
  case "$OPTION" in
    b) boot_img="$OPTARG"
       ;;
    i) Image="$OPTARG"
       ;;
    o) new_boot_img="$OPTARG"
       ;;
    r) ramdisk="$OPTARG"
       new_ramdisk=1
       ;;
    h) help
      exit 1;
      ;;
  esac
done

if [ ! -f ${boot_img} -o ! -f ${Image} ]; then
    echo "Can't find ${boot_img} or ${Image}"
	help
	exit 1;
fi

if [ ${new_ramdisk} -eq 1 ]; then
    if [ ! -f "${ramdisk}" ]; then
        echo "ramdisk: ${ramdisk} not found."
        exit 1;
    fi
fi

unpack_out_dir="unpack_out"
unpack_log_temp_file="unpack.log.tmp"
unpack_log_file="unpack.log"

./unpack_bootimg --boot_img ${boot_img} --out ${unpack_out_dir} > ${unpack_log_temp_file}
# remove all invisible characters
sed $'s/[^[:print:]\t]//g' ${unpack_log_temp_file} > ${unpack_log_file}
rm ${unpack_log_temp_file}

key_os_version="os version: "
key_os_patch_level="os patch level: "
key_header_version="boot image header version: "
key_cmdline="command line args: "
key_additional_cmdline="additional command line args: "
key_kernel_load_address="kernel load address: "
key_ramdisk_load_address="ramdisk load address: "

os_version=`grep "$key_os_version" $unpack_log_file`
os_version=${os_version#*${key_os_version}}
os_patch_level=`grep "$key_os_patch_level" $unpack_log_file`
os_patch_level=${os_patch_level#*${key_os_patch_level}}"-05"
header_version=`grep "$key_header_version" $unpack_log_file`
header_version=${header_version#*${key_header_version}}
cmdline=`grep "$key_cmdline" $unpack_log_file | grep -v "${key_additional_cmdline}"`
cmdline=${cmdline#*${key_cmdline}}
kernel_load_address=`grep "$key_kernel_load_address" $unpack_log_file`
kernel_load_address=${kernel_load_address#*${key_kernel_load_address}}
ramdisk_load_address=`grep "$key_ramdisk_load_address" $unpack_log_file`
ramdisk_load_address=${ramdisk_load_address#*${key_ramdisk_load_address}}
kernel_offset=${BOARD_KERNEL_OFFSET}
board_kernel_base=$((${kernel_load_address}-${kernel_offset}))
ramdisk_offset=$((${ramdisk_load_address}-${board_kernel_base}))

echo "os version: $os_version"
echo "os patch level: $os_patch_level"
echo "header version: $header_version"

if [ -f "${ramdisk}" ]; then
    echo "New ramdisk: ${ramdisk}"
    cp ${ramdisk} ${unpack_out_dir}/ramdisk
fi

echo "Replace ${Image} in ${boot_img} ..."
if [ ${header_version} != "3" ]; then
    echo "cmdline: $cmdline"
    echo "kernel load address: $kernel_load_address"
    echo "ramdisk load address: $ramdisk_load_address"
    echo "kernel offset: $kernel_offset"
    echo "ramdisk offset: $ramdisk_offset"

    ./mkbootimg --kernel ${Image} --ramdisk ${unpack_out_dir}/ramdisk --os_version ${os_version} --os_patch_level ${os_patch_level} \
    --header_version ${header_version} --cmdline "${cmdline}" --base ${board_kernel_base} --kernel_offset ${kernel_offset} \
    --ramdisk_offset ${ramdisk_offset} --output ${new_boot_img}
else
    ./mkbootimg --kernel ${Image} --ramdisk ${unpack_out_dir}/ramdisk --os_version ${os_version} --os_patch_level ${os_patch_level} \
    --header_version ${header_version} --output ${new_boot_img}
fi

echo "Done: ${new_boot_img}"

# clear
rm -rf ${unpack_out_dir} ${unpack_log_file}
