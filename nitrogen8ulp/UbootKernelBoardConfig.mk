TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# TODO update bootloader once ready
TARGET_BOOTLOADER_CONFIG := imx8ulp:tag_2gr0_defconfig imx8ulp:imx8ulp_nitrogen_som_2gr0_defconfig
TARGET_BOOTLOADER_PREBUILT :=

TARGET_KERNEL_DEFCONFIG := boundary_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0
