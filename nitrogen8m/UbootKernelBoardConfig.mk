TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

TARGET_BOOTLOADER_CONFIG := imx8mq:nitrogen8m_defconfig

TARGET_BOOTLOADER_PREBUILT := nitrogen8m nitrogen8m_2g nitrogen8m_4g nitrogen8m_2g_dp nitrogen8m_som_2g nitrogen8m_som_4g bio_4g

TARGET_KERNEL_DEFCONFIG := boundary_android_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0
