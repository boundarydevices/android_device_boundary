LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
include device/fsl-proprietary/codec/fsl-codec.mk
endif

include device/boundary/bootscript.mk

#
# The ramdisk.mk targets are broken.
# See comments in http://boundarydevices.com/android-r13-4-stage-3/ for details
#
#include device/boundary/ramdisk.mk

