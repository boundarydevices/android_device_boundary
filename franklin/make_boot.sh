#!/bin/bash -ex

# Run from top of kitkat source

ROOTFS=$1
PREFIX_CROSS_COMPILE=/opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
DTBTOOL=vendor/amlogic/tools/dtbTool

if [ "$ROOTFS" == "" -o ! -f "$ROOTFS" ]; then
    echo "Usage: $0 <ramdisk.img> [m]"
    exit 1
fi

KERNEL_OUT=out/target/product/franklin/obj/KERNEL_OBJ
mkdir -p $KERNEL_OUT

if [ ! -f $KERNEL_OUT/.config ]; then
    make -C common O=../$KERNEL_OUT meson64_defconfig ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
fi

make -C common O=../$KERNEL_OUT ARCH=arm64 -j6 CROSS_COMPILE=$PREFIX_CROSS_COMPILE modules Image.gz

cp $KERNEL_OUT/arch/arm64/boot/Image.gz out/target/product/franklin/kernel

if [ "$2" != "m" ]; then
    make -C common O=../$KERNEL_OUT g12a_s905x2_u212.dtb ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
    make -C common O=../$KERNEL_OUT g12a_s905x2_u212_1g.dtb ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
    $DTBTOOL -o out/target/product/franklin/dtb.img -p $KERNEL_OUT/scripts/dtc/ $KERNEL_OUT/arch/arm64/boot/dts/amlogic/
fi

if [ "$2" != "m" ]; then
    out/host/linux-x86/bin/mkbootimg --kernel common/../$KERNEL_OUT/arch/arm64/boot/Image.gz \
        --base 0x0 \
        --kernel_offset 0x1080000 \
        --ramdisk ${ROOTFS} \
        --second out/target/product/franklin/dtb.img \
        --output ./out/target/product/franklin/boot.img
    ls -l ./out/target/product/franklin/boot.img
    echo "boot.img done"
fi
