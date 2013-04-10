#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
TARGET_KERNEL_DEFCONF := oc_defconfig

#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := oc
PRODUCT_MODEL := OC

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BOARD_KERNEL_CMDLINE := console=ttymxc1,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc1

TARGET_BOOTLOADER_CONFIG := 6q:ocquad_config 6s:ocsolo_config

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER      := MAC80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
WIFI_DRIVER_MODULE_NAME          := "bcmdhd"

BOARD_USE_AR3K_BLUETOOTH := false
