#!/bin/bash

# hardcode this one again in this shell script
CONFIG_REPO_PATH=device/nxp

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

if [ "${AARCH32_GCC_CROSS_COMPILE}" != "" ]; then
	SM_OEI_CROSS_COMPILE=`eval echo ${AARCH32_GCC_CROSS_COMPILE}`
else
	echo ERROR: \*\*\* env AARCH32_GCC_CROSS_COMPILE is not set
	exit 1
fi

MKIMAGE_SOC=iMX95
BOARD_MKIMAGE_PATH=${IMX_MKIMAGE_PATH}/imx-mkimage/${MKIMAGE_SOC}
BOARD_SM_PATH=${IMX_PATH}/imx-sm
BOARD_OEI_PATH=${IMX_PATH}/imx-oei

build_pre_image()
{
	echo Building imx-sm ...
	make -C ${BOARD_SM_PATH} really-clean
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" cfg config=mx95evk 1>/dev/null || exit 1
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" all config=mx95evk 1>/dev/null || exit 1
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" cfg config=mx95alt 1>/dev/null || exit 1
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" all config=mx95alt 1>/dev/null || exit 1
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" cfg config=mx95evk-android 1>/dev/null || exit 1
	make -C ${BOARD_SM_PATH} SM_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" all config=mx95evk-android 1>/dev/null || exit 1
	echo Building imx-oei ...
	make -C ${BOARD_OEI_PATH} really-clean
	make -C ${BOARD_OEI_PATH} OEI_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" board=mx95lp5 oei=ddr DEBUG=1 1>/dev/null || exit 1
	make -C ${BOARD_OEI_PATH} OEI_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" board=mx95lp5 oei=tcm DEBUG=1 1>/dev/null || exit 1
	make -C ${BOARD_OEI_PATH} OEI_CROSS_COMPILE="${SM_OEI_CROSS_COMPILE}" board=mx95lp4x-15 oei=ddr DEBUG=1 1>/dev/null || exit 1
}

build_imx_uboot()
{
	echo Building i.MX U-Boot with firmware
	if echo "$2" | grep -q "15x15" ; then
		cp ${BOARD_OEI_PATH}/build/mx95lp4x-15/ddr/oei-m33-ddr.bin ${BOARD_MKIMAGE_PATH}/oei-m33-ddr.bin
	else
		cp ${BOARD_OEI_PATH}/build/mx95lp5/ddr/oei-m33-ddr.bin ${BOARD_MKIMAGE_PATH}/oei-m33-ddr.bin
	fi
	cp ${BOARD_OEI_PATH}/build/mx95lp5/tcm/oei-m33-tcm.bin ${BOARD_MKIMAGE_PATH}

	if [ `echo $2 | cut -d '-' -f2` = "trusty" ]; then
		cp ${BOARD_SM_PATH}/build/mx95evk-android/m33_image.bin ${BOARD_MKIMAGE_PATH}/m33_image.bin
	elif [ `echo $2 | cut -d '-' -f2` = "rpmsg" ]; then
		cp ${BOARD_SM_PATH}/build/mx95alt/m33_image.bin ${BOARD_MKIMAGE_PATH}/m33_image.bin
	else
		cp ${BOARD_SM_PATH}/build/mx95evk/m33_image.bin ${BOARD_MKIMAGE_PATH}/m33_image.bin
	fi

	if echo "$2" | grep -q "15x15" ; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx95/imx95_15x15_mcu_demo.img ${BOARD_MKIMAGE_PATH}/m7_image.bin
	elif echo "$2" | grep -q "verdin" ; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx95/imx95_verdin_mcu_demo.img ${BOARD_MKIMAGE_PATH}/m7_image.bin
	else
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx95/imx95_19x19_mcu_demo.img ${BOARD_MKIMAGE_PATH}/m7_image.bin
	fi

	cp ${FSL_PROPRIETARY_PATH}/ele/mx95a0-ahab-container.img ${BOARD_MKIMAGE_PATH}/mx95a0-ahab-container.img
	cp ${UBOOT_OUT}/u-boot.$1 ${BOARD_MKIMAGE_PATH}
	cp ${UBOOT_OUT}/spl/u-boot-spl.bin ${BOARD_MKIMAGE_PATH}
	cp ${UBOOT_OUT}/tools/mkimage ${BOARD_MKIMAGE_PATH}/mkimage_uboot
	cp ${FSL_PROPRIETARY_PATH}/linux-firmware-imx/firmware/ddr/synopsys/lpddr4x_imem_* ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX95/
	cp ${FSL_PROPRIETARY_PATH}/linux-firmware-imx/firmware/ddr/synopsys/lpddr4x_dmem_* ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX95/
	cp ${FSL_PROPRIETARY_PATH}/linux-firmware-imx/firmware/ddr/synopsys/lpddr5_imem_* ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX95/
	cp ${FSL_PROPRIETARY_PATH}/linux-firmware-imx/firmware/ddr/synopsys/lpddr5_dmem_* ${IMX_MKIMAGE_PATH}/imx-mkimage/iMX95/

	# build ATF based on whether tee is involved
	make -C ${IMX_PATH}/arm-trusted-firmware/ PLAT=`echo $2 | cut -d '-' -f1` clean
	if [ `echo $2 | cut -d '-' -f2` = "trusty" ] && [ `echo $2 | rev | cut -d '-' -f1` != "uuu" ]; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/uboot-firmware/imx95/tee-imx95.bin ${BOARD_MKIMAGE_PATH}/tee.bin
		make -C ${IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" PLAT=`echo $2 | cut -d '-' -f1` bl31 -B SPD=trusty 1>/dev/null || exit 1
	else
		if [ -f ${BOARD_MKIMAGE_PATH}/tee.bin ] ; then
			rm -rf ${BOARD_MKIMAGE_PATH}/tee.bin
		fi
		make -C ${IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" PLAT=`echo $2 | cut -d '-' -f1` bl31 -B 1>/dev/null || exit 1
	fi

	cp ${IMX_PATH}/arm-trusted-firmware/build/`echo $2 | cut -d '-' -f1`/release/bl31.bin ${BOARD_MKIMAGE_PATH}/bl31.bin

	make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ clean
	# in imx-mkimage/Makefile, MKIMG is assigned with a value of "$(PWD)/mkimage_imx8", the value of PWD is set by shell to current
	# directory. Directly execute "make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ ..." command in this script, PWD is the top dir of Android
	# codebase, so mkimage_imx8 will be generated under Android codebase top dir.
	pwd_backup=${PWD}
	PWD=${PWD}/${IMX_MKIMAGE_PATH}/imx-mkimage/
	if echo "$2" | grep -q "15x15" ; then
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} flash_all LPDDR_TYPE=lpddr4x OEI=YES || exit 1
	elif [ `echo $2 | cut -d '-' -f2` = "rpmsg" ]; then
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} flash_a55 MSEL=1 LPDDR_TYPE=lpddr5 OEI=YES || exit 1
	else
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} flash_all LPDDR_TYPE=lpddr5 OEI=YES || exit 1
	fi

	PWD=${pwd_backup}

	if [ `echo $2 | rev | cut -d '-' -f1 | rev` != "dual" ]; then
		cp ${BOARD_MKIMAGE_PATH}/flash.bin ${UBOOT_COLLECTION}/u-boot-$2.imx
	else
		cp ${BOARD_MKIMAGE_PATH}/boot-spl-container.img ${UBOOT_COLLECTION}/spl-$2.bin
		cp ${BOARD_MKIMAGE_PATH}/u-boot-atf-container.img ${UBOOT_COLLECTION}/bootloader-$2.img
	fi

}
