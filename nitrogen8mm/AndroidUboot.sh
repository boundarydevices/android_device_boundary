#!/bin/bash

# hardcode this one again in this shell script
CONFIG_REPO_PATH=device/ezurio

# import other paths in the file "common/imx_path/ImxPathConfig.mk" of this
# repository

while read -r line
do
	if [ "$(echo ${line} | grep "=")" != "" ]; then
		env_arg=`echo ${line} | cut -d "=" -f1`
		env_arg=${env_arg%:}
		env_arg=`eval echo ${env_arg}`

		env_arg_value=`echo ${line} | cut -d "=" -f2`
		env_arg_value=`eval echo ${env_arg_value}`

		eval ${env_arg}=${env_arg_value}
	fi
done < ${CONFIG_REPO_PATH}/common/imx_path/ImxPathConfig.mk


if [ "${AARCH64_GCC_CROSS_COMPILE}" != "" ]; then
    ATF_CROSS_COMPILE=`eval echo ${AARCH64_GCC_CROSS_COMPILE}`
else
    echo ERROR: \*\*\* env AARCH64_GCC_CROSS_COMPILE is not set
    exit 1
fi

build_pre_image()
{
	:
}

build_imx_uboot()
{
	echo Building i.MX U-Boot with firmware
    cp ${FSL_PROPRIETARY_PATH}/linux-firmware-imx/firmware/ddr/synopsys/lpddr4_pmu_train* ${UBOOT_OUT}
    if [ ${clean_build} = 1 ]; then
        make -C ${ATF_IMX_PATH}/arm-trusted-firmware/ PLAT=`echo ${2} | cut -d '-' -f1` clean
    fi
    if [ `echo ${2} | cut -d '-' -f2` = "trusty" ] && [ `echo ${2} | rev | cut -d '-' -f1` != "uuu" ]; then
        cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/uboot-firmware/imx8m/tee-imx8mm.bin ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX8M/tee.bin
        make -C ${ATF_IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" ${CLANG_TO_COMPILE} PLAT=`echo ${2} | cut -d '-' -f1` bl31 -B SPD=trusty || exit 1
    else
        if [ -f ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX8M/tee.bin ] ; then
            rm -rf ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX8M/tee.bin
        fi
        make -C ${ATF_IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" ${CLANG_TO_COMPILE} PLAT=`echo ${2} | cut -d '-' -f1` bl31 -B || exit 1
    fi
    cp ${ATF_IMX_PATH}/arm-trusted-firmware/build/`echo ${2} | cut -d '-' -f1`/release/bl31.bin ${UBOOT_OUT}/bl31-iMX8MM.bin
    make -C ${UBOOT_IMX_PATH}/uboot-imx/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" O=$(realpath ${UBOOT_OUT}) flash.bin
    cp ${UBOOT_OUT}/flash.bin ${UBOOT_COLLECTION}/;
}
