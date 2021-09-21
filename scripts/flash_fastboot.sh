#!/bin/sh

if [ -z "$product" ]; then product=nitrogen8m; fi

help() {
cat << EOF

Usage: $0 <options>

options:
  -h                displays this help message
  -d <directory>    the directory of images (default: \$OUT)
  -D                disables verity verification
  -p <product_name> product/target being flashed (default: $product)
  -s <mmc_size>     size of the mmc being flashed (8/16)
  -u                do NOT erase userdata during the flashing process

EOF
}

# Parse parameters
skip_userdata=0
gpt_size=0
disable_verity=""
while [ $# -gt 0 ]; do
	case $1 in
		-h) help; exit ;;
		-d) OUT=$2; shift;;
		-D) disable_verity="--disable-verity";;
		-p) product=$2; shift;;
		-s) gpt_size=$2; shift;;
		-u) skip_userdata=1 ;;
		*)  echo "$1 is not a known option";
			help; exit;;
	esac
	shift
done
case $gpt_size in
	0*) gpt=partition-table-default.img;;
	8*) gpt=partition-table-8GB.img;;
	16*) gpt=partition-table-16GB.img;;
	32*) gpt=partition-table-32GB.img;;
	64*) gpt=partition-table-64GB.img;;
	128*) gpt=partition-table-128GB.img;;
	*) echo "Unsupported GPT size: $gpt_size";
		help; exit;;
esac

if [ -z "$OUT" ]; then OUT=out/target/product/$product; fi
if ! [ -d $OUT ]; then
   echo "Missing $OUT";
   exit 1;
fi

fastboot flash gpt $OUT/$gpt
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
fastboot flash vbmeta $OUT/vbmeta.img $disable_verity
if ! [ $? -eq 0 ] ; then echo "Failed to flash vbmeta.img"; exit 1; fi
fastboot flash cache $OUT/cache.img
if ! [ $? -eq 0 ] ; then echo "Failed to flash cache.img"; exit 1; fi
if ! [ ${skip_userdata} -eq 1 ] ; then
	fastboot erase userdata
	fastboot erase metadata
	if ! [ $? -eq 0 ] ; then echo "Failed to erase userdata"; exit 1; fi
fi
fastboot reboot
