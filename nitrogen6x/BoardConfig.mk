#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
TARGET_KERNEL_DEFCONF := nitrogen6x_defconfig

#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := SABRELITE
PRODUCT_MODEL := NITROGEN6X

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BOARD_KERNEL_CMDLINE := console=ttymxc1,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc1

TARGET_BOOTLOADER_CONFIG := 6q:nitrogen6x_config 6dl:nitrogen6x_config 6s:nitrogen6x_config


