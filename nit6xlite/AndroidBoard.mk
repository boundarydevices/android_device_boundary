LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
include device/fsl-proprietary/media-profile/media-profile.mk

TARGET_BOOTLOADER_DIR=nit6xlite
TARGET_BOARD_DTS_CONFIG=imx6dl:imx6dl-nit6xlite.dtb
include device/boundary/bootscript.mk
include device/boundary/ramdisk.mk

