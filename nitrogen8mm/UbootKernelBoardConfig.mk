TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

TARGET_BOOTLOADER_CONFIG := imx8mm:nitrogen8mm_2g_defconfig

TARGET_BOOTLOADER_PREBUILT := nitrogen8mm_2g nitrogen8mm_4g nitrogen8mm_rev2_2g nitrogen8mm_som_2g nitrogen8mm_som_4g imx8mm_nitrogen_smarc_2gr0

TARGET_KERNEL_DEFCONFIG := boundary_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0
