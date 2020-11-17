#
# Board-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MM
BOARD_TYPE := Nitrogen
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := true
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := false
BOARD_KERNEL_BASE := 0x40400000
TARGET_GRALLOC_VERSION := v3
TARGET_HIGH_PERFORMANCE := true
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
USE_OPENGL_RENDERER := true
TARGET_HAVE_VULKAN := true
ENABLE_CFI=false

SOONG_CONFIG_IMXPLUGIN += \
                          BOARD_HAVE_VPU \
                          BOARD_VPU_TYPE

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MM
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro

IMX_DEVICE_PATH := device/boundary/nitrogen8mm

# Add preboot partition for ref design simplicity
BOARD_HAVE_PREBOOTIMAGE := true

include device/boundary/common/imx8m/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

# OTA configuration
AB_OTA_UPDATER := false

# Create recovery image since not using A/B
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 50331648
TARGET_NO_RECOVERY := false

# Create cache image since not using A/B
BOARD_CACHEIMAGE_PARTITION_SIZE := 1073741824
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale

# Support gpt
BOARD_BPT_INPUT_FILES += device/boundary/common/partition/device-partitions-8GB.bpt
ADDITION_BPT_PARTITION = partition-table-16GB:device/boundary/common/partition/device-partitions-16GB.bpt \
    partition-table-8GB:device/boundary/common/partition/device-partitions-8GB.bpt \
    partition-table-32GB:device/boundary/common/partition/device-partitions-32GB.bpt \
    partition-table-64GB:device/boundary/common/partition/device-partitions-64GB.bpt \
    partition-table-128GB:device/boundary/common/partition/device-partitions-128GB.bpt \

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := nitrogen8mm

USE_OPENGL_RENDERER := true

BOARD_WLAN_DEVICE            := qcwcn
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB           := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB    := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM        := true

BOARD_USE_SENSOR_FUSION := false

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/boundary/common/security/testkey_rsa4096.pem

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=800M
endif

BOARD_KERNEL_CMDLINE := init=/init androidboot.hardware=freescale firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += transparent_hugepage=never loop.max_part=7

# Default wificountrycode
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=US

BOARD_PREBUILT_DTBOIMAGE := out/target/product/nitrogen8mm/dtbo-imx8mm.img
TARGET_BOARD_DTS_CONFIG ?= \
	imx8mm:imx8mm-nitrogen8mm.dtb \
	imx8mm:imx8mm-nitrogen8mm-m4.dtb \
	imx8mm:imx8mm-nitrogen8mm_rev2.dtb \
	imx8mm:imx8mm-nitrogen8mm_rev2-m4.dtb \
	imx8mm:imx8mm-nitrogen8mm_som.dtb \
	imx8mm:imx8mm-nitrogen8mm_som-m4.dtb \
	imx8mm:imx8mm-nitrogen8mm_som-mcp25625.dtb \
	imx8mm:imx8mm-nitrogen8mm-tc358743.dtb \

BOARD_SEPOLICY_DIRS := \
       device/boundary/common/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       $(IMX_DEVICE_PATH)/sepolicy_drm
endif

TARGET_BOARD_KERNEL_HEADERS := device/boundary/common/kernel-headers

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)
