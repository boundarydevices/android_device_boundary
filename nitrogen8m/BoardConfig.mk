# -------@block_infrastructure-------
#
# Product-specific compile-time definitions.
#

AB_OTA_UPDATER ?= false
BOARD_HAVE_PREBOOTIMAGE := true
BOARD_USES_SYSTEM_EXTIMAGE := false
IMX_DEVICE_PATH := device/boundary/nitrogen8m

include $(CONFIG_REPO_PATH)/common/imx8m/BoardConfigCommon.mk

# -------@block_common_config-------
#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MQ
BOARD_TYPE := Nitrogen
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_PXP := false
TARGET_USES_HWC2 := true
TARGET_HAVE_VULKAN := true

SOONG_CONFIG_IMXPLUGIN += \
                          BOARD_VPU_TYPE \

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MQ
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_ONLY = false
SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_CODEC = true
SOONG_CONFIG_IMXPLUGIN_POWERSAVE = false

# -------@block_memory-------
USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# -------@block_storage-------
TARGET_USERIMAGES_USE_EXT4 := true

# use sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# Support gpt
ifeq ($(AB_OTA_UPDATER),false)
BOARD_BPT_INPUT_FILES += $(CONFIG_REPO_PATH)/common/partition/device-partitions-16GB.bpt
ADDITION_BPT_PARTITION = partition-table-16GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-16GB.bpt \
    partition-table-8GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-8GB.bpt \
    partition-table-32GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-32GB.bpt \
    partition-table-64GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-64GB.bpt \
    partition-table-128GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-128GB.bpt \

else
BOARD_BPT_INPUT_FILES += $(CONFIG_REPO_PATH)/common/partition/device-partitions-16GB-ab.bpt
ADDITION_BPT_PARTITION = partition-table-16GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-16GB-ab.bpt \
    partition-table-8GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-8GB-ab.bpt \
    partition-table-32GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-32GB-ab.bpt \
    partition-table-64GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-64GB-ab.bpt \
    partition-table-128GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-128GB-ab.bpt \

endif

BOARD_PREBUILT_DTBOIMAGE := $(OUT_DIR)/target/product/$(PRODUCT_DEVICE)/dtbo-imx8mq.img

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

# system-as-root is not possible for non-A/B or A/B with dynamic partitions
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Necessary changes for non-A/B partitioning
ifeq ($(AB_OTA_UPDATER),false)
TARGET_RELEASETOOLS_EXTENSIONS := $(CONFIG_REPO_PATH)/common/imx8m
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
TARGET_NO_RECOVERY := false
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_CACHEIMAGE_PARTITION_SIZE := 1073741824
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

# -------@block_security-------
ENABLE_CFI=true

BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := $(CONFIG_REPO_PATH)/common/security/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 0
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 3
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# -------@block_treble-------
# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(IMX_DEVICE_PATH)/device_framework_matrix.xml
ifeq ($(TARGET_USE_HDMI_CEC),true)
DEVICE_MANIFEST_FILE += vendor/nxp-opensource/imx/hdmicec/manifest.xml
endif

# -------@block_wifi-------
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

# -------@block_bluetooth-------
BOARD_HAVE_BLUETOOTH         := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# -------@block_sensor-------
BOARD_USE_SENSOR_FUSION := false

# -------@block_kernel_bootimg-------
BOARD_KERNEL_BASE := 0x40400000

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=1280M
endif
BOARD_KERNEL_CMDLINE := init=/init androidboot.hardware=nxp firmware_class.path=/vendor/firmware loop.max_part=7

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never

# wifi config
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=US

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += androidboot.vendor.sysrq=1
endif

TARGET_BOARD_DTS_CONFIG ?= \
	imx8mq:imx8mq-nitrogen8m.dtb \
	imx8mq:imx8mq-nitrogen8m-avt.dtb \
	imx8mq:imx8mq-nitrogen8m-edp.dtb \
	imx8mq:imx8mq-nitrogen8m-gbr.dtb \
	imx8mq:imx8mq-nitrogen8m-m4.dtb \
	imx8mq:imx8mq-nitrogen8m_som.dtb \
	imx8mq:imx8mq-nitrogen8m_som-sd.dtb \
	imx8mq:imx8mq-nitrogen8m_som-m4.dtb \
	imx8mq:imx8mq-nitrogen8m-tc358743.dtb \
	imx8mq:imx8mq-nitrogen8m-tc358840.dtb \
	imx8mq:imx8mq-bio.dtb \

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

# -------@block_sepolicy-------
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(CONFIG_REPO_PATH)/common/imx8m/system_ext_pri_sepolicy

BOARD_SEPOLICY_DIRS := \
       $(CONFIG_REPO_PATH)/common/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       $(IMX_DEVICE_PATH)/sepolicy_drm
endif

