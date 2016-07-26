LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := powerfail.c
LOCAL_MODULE := powerfail
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := liblog libcutils

include $(BUILD_EXECUTABLE)
