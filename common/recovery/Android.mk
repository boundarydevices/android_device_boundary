LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES += \
    bootable/recovery \
    bootable/recovery/recovery_ui/include
LOCAL_SRC_FILES := recovery_ui.cpp

# should match TARGET_RECOVERY_UI_LIB set in BoardConfigCommon.mk
LOCAL_MODULE := librecovery_ui_imx

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
