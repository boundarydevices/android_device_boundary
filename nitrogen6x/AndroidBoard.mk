LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
include device/fsl-proprietary/media-profile/media-profile.mk

TARGET_BOOTLOADER_DIR=nitrogen6x
TARGET_BOARD_DTS_CONFIG=imx6q:imx6q-nitrogen6x.dtb imx6dl:imx6dl-nitrogen6x.dtb imx6q:imx6q-nitrogen6_max.dtb imx6q:imx6q-sabrelite.dtb imx6q:imx6q-xdyn.dtb imx6dl:imx6dl-nitrogen6_vm.dtb
include device/boundary/bootscript.mk
include device/boundary/ramdisk.mk

