#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6sx.mk
export BUILD_ID=1.0.0-ga
export BUILD_NUMBER=20160530
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := boundary_defconfig
endif

TARGET_RECOVERY_FSTAB := device/boundary/nitrogen6sx/fstab.freescale

# boot.img & recovery.img creation
TARGET_BOOTIMAGE_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 20940800
TARGET_RECOVERYIMAGE_USE_EXT4 := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 20940800

BOARD_HAS_SGTL5000 := true

BOARD_HAS_SENSOR := false
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

PRODUCT_MODEL := NITROGEN6SX

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

# WiFi/BT common defines
BOARD_HAVE_WIFI                  := true
BOARD_HAVE_BLUETOOTH             := true
WPA_BUILD_HOSTAPD                := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_HOSTAPD_DRIVER             := NL80211

BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE                := bcmdhd
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/brcmfmac.ko"
WIFI_DRIVER_MODULE_NAME          := "brcmfmac"
WIFI_DRIVER_MODULE_ARG           := "p2pon=1"
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_bcmdhd
BOARD_HAVE_BLUETOOTH_BCM         := true
TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko:system/lib/modules/brcmutil.ko \
    kernel_imx/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko:system/lib/modules/brcmfmac.ko

# SoftAP workaround
WIFI_BYPASS_FWRELOAD      := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/boundary/nitrogen6sx/

include device/boundary/sepolicy.mk

