#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8mq.mk
export BUILD_ID=1.3.0-ga
export BUILD_NUMBER=$(shell date +%Y%m%d)

# OTA configuration
TARGET_OTA_BLOCK_DISABLED := true
AB_OTA_UPDATER := false

include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

# Kernel / device tree configuration
TARGET_KERNEL_DEFCONF := boundary_android_defconfig
TARGET_BOARD_DTS_CONFIG := \
	imx8mq:imx8mq-nitrogen8m.dtb

# Bootloader configuration
TARGET_BOOTLOADER_BOARD_NAME := nitrogen8m
TARGET_BOOTLOADER_CONFIG := \
	nitrogen8m_defconfig
TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# Misc configuration
TARGET_COPY_OUT_VENDOR := vendor
TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx8
TARGET_CPU_SMP := true

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := device/boundary/nitrogen8m/manifest.xml
DEVICE_MATRIX_FILE := device/boundary/nitrogen8m/compatibility_matrix.xml

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt

# Override Freescale partition sizes to match our flashing script
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1744830464
BOARD_CACHEIMAGE_PARTITION_SIZE := 536870912
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# boot.img & recovery.img creation
TARGET_BOOTIMAGE_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 37748736
TARGET_RECOVERYIMAGE_USE_EXT4 := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 37748736

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

# For recovery service
TARGET_SELECT_KEY := 28
TARGET_RECOVERY_FSTAB := device/boundary/nitrogen8m/fstab.freescale

# Camera
IMX_CAMERA_HAL_V3 := true
BOARD_HAVE_USB_CAMERA := true

PRODUCT_MODEL := Nitrogen8m

# GPU configuration
USE_OPENGL_RENDERER := true
USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 5
BOARD_EGL_CFG := $(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib64/egl/egl.cfg

# WiFi/BT configuration
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
BOARD_VENDOR_KERNEL_MODULES += \
	$(TARGET_OUT_INTERMEDIATES)/ETC/qcacld_wlan.ko_intermediates/qcacld_wlan.ko

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/boundary/nitrogen8m/

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=1536M
endif

include device/boundary/sepolicy.mk

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
