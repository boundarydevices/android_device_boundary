# below variables are defined in AOSP build makefile, to build kernel independently, redefine them here
hide := @

PRODUCT_OUT := ${OUT}
TARGET_OUT_INTERMEDIATES := $(PRODUCT_OUT)/obj
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

# HOST_OS
UNAME := $(shell uname -sm)
ifneq (,$(findstring Linux,$(UNAME)))
  HOST_OS := linux
endif
ifneq (,$(findstring Darwin,$(UNAME)))
  HOST_OS := darwin
endif
ifneq (,$(findstring Macintosh,$(UNAME)))
  HOST_OS := darwin
endif

HOST_PREBUILT_ARCH := x86

HOST_PREBUILT_TAG := $(HOST_OS)-${HOST_PREBUILT_ARCH}

# firstly to include UbootKernelCommonConfig.mk, then SharedBoardConfig.mk, finally UbootKernelBoardConfig.mk

include ${fsl_git_path}/common/imx_path/ImxPathConfig.mk
include ${soc_path}/UbootKernelCommonConfig.mk
include ${product_path}/SharedBoardConfig.mk
include ${product_path}/UbootKernelBoardConfig.mk

include ${fsl_git_path}/common/build/kernel.mk
include ${fsl_git_path}/common/build/uboot.mk
-include ${product_path}/AndroidUboot.mk
-include ${product_path}/AndroidTee.mk

