#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=4.4.2_1.0.0-ga
export BUILD_NUMBER=20140908
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := utc_defconfig
endif

TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/wl12xx/wl12xx_sdio.ko:system/lib/modules/wl12xx_sdio.ko

BOARD_HAS_SGTL5000 := true
BOARD_HAVE_BLUETOOTH := true
USE_CAMERA_STUB := false
BOARD_CAMERA_LIBRARIES := libcamera

BOARD_HAVE_WIFI := true

BOARD_HAVE_MODEM := false
BOARD_HAVE_IMX_CAMERA := true
BOARD_HAVE_USB_CAMERA := false
BOARD_HAS_SENSOR := false
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

PRODUCT_MODEL := UTC

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

BOARD_KERNEL_CMDLINE := console=ttymxc1,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc1

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
# wpa_supplicant.conf provided by hardware/ti/wlan
SKIP_WPA_SUPPLICAN_CONF		 := y
SKIP_WPA_SUPPLICANT_RTL		 := y
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
WIFI_DRIVER_MODULE_PATH		 := "/system/lib/modules/wl12xx_sdio.ko"

BOARD_USE_AR3K_BLUETOOTH := 
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/boundary/utc/

