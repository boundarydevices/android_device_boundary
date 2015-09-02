LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
include device/fsl-proprietary/media-profile/media-profile.mk

TARGET_BOOTLOADER_DIR=nitrogen6sx
TARGET_BOARD_DTS_CONFIG=imx6sx:imx6sx-nitrogen6sx.dtb
include device/boundary/bootscript.mk
include device/boundary/ramdisk.mk

