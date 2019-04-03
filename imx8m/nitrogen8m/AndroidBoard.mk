LOCAL_PATH := $(call my-dir)

include device/boundary/common/build/kernel.mk
include device/boundary/common/build/uboot.mk
include device/boundary/common/build/dtbo.mk
include device/boundary/common/build/imx-recovery.mk
include device/boundary/common/build/gpt.mk
include $(LOCAL_PATH)/AndroidUboot.mk
include $(LOCAL_PATH)/AndroidTee.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
