# -------@block_infrastructure-------
#
# Product-specific compile-time definitions.
#

AB_OTA_UPDATER ?= false
BOARD_HAVE_PREBOOTIMAGE := true
BOARD_USES_SYSTEM_EXTIMAGE := false
IMX_DEVICE_PATH := device/ezurio/nitrogen95

include $(CONFIG_REPO_PATH)/common/imx9/BoardConfigCommon.mk

# -------@block_common_config-------
#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX95
BOARD_TYPE := Nitrogen
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := wave6
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_PXP := false
TARGET_USES_HWC2 := true
TARGET_HAVE_VULKAN := true
CFG_SECURE_IOCTRL_REGS := true
ENABLE_SEC_DMABUF_HEAP := true
MEDIA_PIPELINE := NEOISP

SOONG_CONFIG_IMXPLUGIN += \
                        BOARD_VPU_TYPE \
                        CFG_SECURE_IOCTRL_REGS \
                        ENABLE_SEC_DMABUF_HEAP \
                        MEDIA_PIPELINE

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX95
SOONG_CONFIG_IMXPLUGIN_HAVE_FSL_IMX_GPU3D = true
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = wave6
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_ONLY = false
SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_CODEC = true
SOONG_CONFIG_IMXPLUGIN_CFG_SECURE_IOCTRL_REGS = true
SOONG_CONFIG_IMXPLUGIN_ENABLE_SEC_DMABUF_HEAP = true
SOONG_CONFIG_IMXPLUGIN_MEDIA_PIPELINE = NEOISP

BOARD_GPU_DRIVERS := mali

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

BOARD_PREBUILT_DTBOIMAGE := $(OUT_DIR)/target/product/$(PRODUCT_DEVICE)/dtbo-imx95.img

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

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
ifeq ($(AB_OTA_UPDATER),false)
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 0
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 3
else
# Enable chained vbmeta for init_boot images
BOARD_AVB_INIT_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_INIT_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX_LOCATION := 3
endif

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

# Use sha256 hashtree
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# -------@block_treble-------
# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml

DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(IMX_DEVICE_PATH)/device_framework_matrix.xml

# -------@block_wifi-------
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# -------@block_bluetooth-------
BOARD_HAVE_BLUETOOTH         := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# -------@block_kernel_bootimg-------
BOARD_KERNEL_BASE := 0x90400000

# NXP default config
BOARD_KERNEL_CMDLINE := init=/init androidboot.hardware=nxp firmware_class.path=/vendor/firmware loop.max_part=7

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never

# display config
BOARD_KERNEL_CMDLINE += androidboot.dpu_composition=1

# wifi config
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=US
BOARD_KERNEL_CMDLINE += moal.mod_para=nxp/wifi_prod_serdev_params.conf

# Add KVM support
BOARD_KERNEL_CMDLINE += androidboot.hypervisor.vm.supported=true

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += androidboot.vendor.sysrq=1
endif

TARGET_BOARD_DTS_CONFIG ?= \
	imx95:imx95-nitrogen-smarc.dtb \
	imx95:imx95-nitrogen-smarc-csi0-pivariety.dtbo \
	imx95:imx95-nitrogen-smarc-csi0-tevs.dtbo \
	imx95:imx95-nitrogen-smarc-csi1-pivariety.dtbo \
	imx95:imx95-nitrogen-smarc-csi1-tevs.dtbo \
	imx95:imx95-nitrogen-smarc-dsi.dtbo \
	imx95:imx95-nitrogen-smarc-lvds0.dtbo \
	imx95:imx95-nitrogen-smarc-lvds1.dtbo \
	imx95:imx95-nitrogen-smarc-nx611.dtbo \

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

# -------@block_sepolicy-------
BOARD_SEPOLICY_DIRS := \
       $(CONFIG_REPO_PATH)/common/imx9/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy
