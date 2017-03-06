#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=2.0.1-ga
export BUILD_NUMBER=20160816
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := nitrogen6x_defconfig
endif

TARGET_RECOVERY_FSTAB := device/boundary/lshore/fstab.freescale

TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/ti/wl12xx/wl12xx.ko:system/lib/modules/wl12xx.ko \

BOARD_HAS_SGTL5000 := true
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_TI := true
USE_CAMERA_STUB := false
BOARD_CAMERA_LIBRARIES := libcamera

BOARD_HAVE_WIFI := true

BOARD_NOT_HAVE_MODEM := true
BOARD_HAVE_IMX_CAMERA := true
BOARD_HAVE_USB_CAMERA := false
BOARD_HAS_SENSOR := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

PRODUCT_MODEL := LSHORE

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
WIFI_DRIVER_MODULE_NAME          := "wl12xx"
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl12xx.ko"

# WiFi Direct requirements
WPA_BUILD_HOSTAPD         := true
BOARD_HOSTAPD_DRIVER      := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_SOFTAP_DEVICE       := wl12xx_mac80211
USES_TI_MAC80211          := true
COMMON_GLOBAL_CFLAGS      += -DUSES_TI_MAC80211

# SoftAP workaround
WIFI_BYPASS_FWRELOAD      := true

BOARD_USE_AR3K_BLUETOOTH := 
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/boundary/lshore/

include device/boundary/sepolicy.mk

