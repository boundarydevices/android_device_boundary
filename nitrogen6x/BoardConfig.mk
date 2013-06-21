#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=1.0.0-rc3
include device/fsl/imx6/BoardConfigCommon.mk
TARGET_KERNEL_DEFCONF := nitrogen6x_defconfig
TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/wl12xx/wl12xx_sdio.ko:boot/lib/modules/wl12xx_sdio.ko

BOARD_HAS_SGTL5000 := true
BOARD_HAVE_BLUETOOTH := false
USE_CAMERA_STUB := false
BOARD_CAMERA_LIBRARIES := libcamera

BOARD_HAVE_WIFI := false

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

TARGET_BOOTLOADER_BOARD_NAME := NITROGEN6X
PRODUCT_MODEL := NITROGEN6X

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

BOARD_KERNEL_CMDLINE := console=ttymxc1,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc1

TARGET_BOOTLOADER_CONFIG := 6q:nitrogen6q_config 6dl:nitrogen6dl_config 6s:nitrogen6s_config

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
BOARD_USE_AR3K_BLUETOOTH := false
