#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=1.0.0-ga
export BUILD_NUMBER=$(shell date +%Y%m%d)
include device/fsl/imx6/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

TARGET_BOOTLOADER_BOARD_NAME := cid_tab
TARGET_BOOTLOADER_DIR=cid_tab
TARGET_BOOTLOADER_POSTFIX := imx
#TARGET_BOOTLOADER_CONFIG := cid_tab_q2g_defconfig

TARGET_KERNEL_DEFCONF := boundary_android_defconfig
TARGET_BOARD_DTS_CONFIG= \
	imx6q:imx6q-cid_tab.dtb

TARGET_RECOVERY_FSTAB := device/boundary/cid_tab/fstab.freescale

TARGET_OTA_BLOCK_DISABLED := true

TARGET_COPY_OUT_VENDOR := vendor

# override Freescale partition sizes to match our flashing script
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1778368000
BOARD_CACHEIMAGE_PARTITION_SIZE := 536870912
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# boot.img & recovery.img creation
TARGET_BOOTIMAGE_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 20940800
TARGET_RECOVERYIMAGE_USE_EXT4 := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 20940800

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

BOARD_NOT_HAVE_MODEM := true
BOARD_HAS_SENSOR := false
IMX6_CONSUMER_IR_HAL := false

# Camera
BOARD_HAVE_IMX_CAMERA := true
BOARD_HAVE_USB_CAMERA := false
IMX_CAMERA_HAL_V3 := true
USE_CAMERA_STUB := false
BOARD_HAVE_FLASHLIGHT := true
BOARD_HAS_BATTERY_LIGHTS := true

PRODUCT_MODEL := CID-TAB

# for recovery service
TARGET_SELECT_KEY := 28

# Define frame buffer count to match IPU
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# GPU configuration
USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false
BOARD_EGL_CFG := $(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib/egl/egl.cfg

# WiFi/BT common defines
BOARD_HAVE_WIFI                  := true
BOARD_HAVE_BLUETOOTH             := true
WPA_BUILD_HOSTAPD                := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_HOSTAPD_DRIVER             := NL80211

BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                := qcwcn
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_qcwcn
BOARD_HAVE_BLUETOOTH_QCOM        := true
BOARD_SUPPORTS_BLE_VND           := true

# SoftAP workaround
WIFI_BYPASS_FWRELOAD      := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/boundary/cid_tab/

include device/boundary/sepolicy.mk
include hardware/sierra/sepolicy.mk

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
