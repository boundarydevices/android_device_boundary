TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

TARGET_BOOTLOADER_CONFIG := imx8mm:nitrogen8_lite_8mm2g_defconfig imx8mm:nitrogen8_lite_8mm2gr0_defconfig

TARGET_BOOTLOADER_PREBUILT := nitrogen8_lite_8mm2g nitrogen8_lite_8mm2gr0

TARGET_KERNEL_DEFCONFIG := boundary_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0
