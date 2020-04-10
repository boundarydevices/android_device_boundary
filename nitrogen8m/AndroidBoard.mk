LOCAL_PATH := $(call my-dir)

include device/boundary/common/build/dtbo.mk
include device/boundary/common/build/gpt.mk
include device/boundary/common/build/bootscript.mk
include device/boundary/common/build/preboot.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
