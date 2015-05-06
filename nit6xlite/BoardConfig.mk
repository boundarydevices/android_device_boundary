#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=4.4.3_2.0.0-ga
export BUILD_NUMBER=20150429
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := nit6xlite_defconfig
endif

TARGET_RECOVERY_FSTAB := device/boundary/nit6xlite/fstab.freescale

TARGET_BOARD_DTS_CONFIG=imx6dl:imx6dl-nit6xlite.dtb
TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko:system/lib/modules/brcmutil.ko \
    kernel_imx/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko:system/lib/modules/brcmfmac.ko

PRODUCT_MODEL := NIT6X
BOARD_HAS_SGTL5000 := true
BOARD_HAS_SENSOR := false
BOARD_HAVE_WIFI := true
BOARD_NOT_HAVE_MODEM := true
BOARD_HAVE_IMX_CAMERA := false
BOARD_HAVE_USB_CAMERA := false

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
# Wifi related defines
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/brcmfmac.ko"
WIFI_DRIVER_MODULE_NAME     := "brcmfmac"
WIFI_DRIVER_MODULE_ARG      := "p2pon=1"

# WiFi Direct requirements
WPA_BUILD_HOSTAPD         := true
BOARD_HOSTAPD_DRIVER      := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd

BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_USE_AR3K_BLUETOOTH :=
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR=device/boundary/nit6xlite/

include device/boundary/sepolicy.mk

