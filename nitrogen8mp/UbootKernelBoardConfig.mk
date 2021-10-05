TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

TARGET_BOOTLOADER_CONFIG := imx8mp-trusty:nitrogen8mp_2gr0_defconfig imx8mp-trusty:u-boot.nitrogen8mp_4g
TARGET_BOOTLOADER_PREBUILT := nitrogen8mp_2gr0 nitrogen8mp_4g

TARGET_KERNEL_DEFCONFIG := boundary_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0
