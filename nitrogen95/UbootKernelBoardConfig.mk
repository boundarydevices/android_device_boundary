# from BoardConfig.mk
TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# u-boot target
TARGET_BOOTLOADER_CONFIG := imx95:imx95_nitrogen_smarc_defconfig

TARGET_KERNEL_DEFCONFIG := ezurio_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

