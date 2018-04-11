LOCAL_PATH := $(call my-dir)

include device/boundary/bootscript.mk
include device/boundary/ramdisk.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
