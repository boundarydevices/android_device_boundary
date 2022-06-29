# -------@block_common_config-------

ENABLE_DMABUF_HEAP := true

SOONG_CONFIG_NAMESPACES += IMXPLUGIN
SOONG_CONFIG_IMXPLUGIN += BOARD_PLATFORM \
NUM_FRAMEBUFFER_SURFACE_BUFFERS \
BOARD_USE_SENSOR_FUSION \
BOARD_SOC_CLASS \
HAVE_FSL_IMX_GPU3D \
TARGET_HWCOMPOSER_VERSION \
TARGET_GRALLOC_VERSION \
PREBUILT_FSL_IMX_GPU \
BOARD_SOC_TYPE \
PRODUCT_MANUFACTURER \
BOARD_VPU_ONLY \
BOARD_HAVE_VPU \
ENABLE_DMABUF_HEAP

SOONG_CONFIG_IMXPLUGIN_BOARD_PLATFORM = imx8
SOONG_CONFIG_IMXPLUGIN_BOARD_USE_SENSOR_FUSION = true
SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_CLASS = IMX8
SOONG_CONFIG_IMXPLUGIN_HAVE_FSL_IMX_GPU3D = true
SOONG_CONFIG_IMXPLUGIN_ENABLE_DMABUF_HEAP = true

#
# Product-specific compile-time definitions.
#

ifeq ($(IMX8_BUILD_32BIT_ROOTFS),true)
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a9
TARGET_USES_64_BIT_BINDER := true
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a9
endif

BOARD_SOC_CLASS := IMX8
SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER = nxp

# -------@block_kernel_bootimg-------
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true


BOARD_KERNEL_OFFSET := 0x00080000
BOARD_RAMDISK_OFFSET := 0x04280000
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INCLUDE_DTB_IN_BOOTIMG := false
else
BOARD_BOOT_HEADER_VERSION := 1
endif

BOARD_MKBOOTIMG_ARGS = --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --header_version $(BOARD_BOOT_HEADER_VERSION)

ifeq ($(TARGET_USE_VENDOR_BOOT),true)
  BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
else
  BOARD_USES_RECOVERY_AS_BOOT := true
endif

# kernel module's copy to vendor need this folder setting
KERNEL_OUT ?= $(OUT_DIR)/target/product/$(PRODUCT_DEVICE)/obj/KERNEL_OBJ

PRODUCT_COPY_FILES += \
    $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/$(KERNEL_NAME):kernel

TARGET_BOARD_KERNEL_HEADERS := $(CONFIG_REPO_PATH)/common/kernel-headers

TARGET_IMX_KERNEL ?= false
ifeq ($(TARGET_IMX_KERNEL),false)
# boot-debug.img is built by IMX, with Google released kernel Image
# boot.img is released by Google
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_PREBUILT_BOOTIMAGE := vendor/nxp/fsl-proprietary/gki/boot-debug.img
else
BOARD_PREBUILT_BOOTIMAGE := vendor/nxp/fsl-proprietary/gki/boot.img
endif
TARGET_NO_KERNEL := true
endif

# -------@block_app-------
# Enable dex-preoptimization to speed up first boot sequence
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif

# -------@block_storage-------
AB_OTA_UPDATER := true
ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
AB_OTA_PARTITIONS += dtbo boot system system_ext vendor vbmeta
else
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
AB_OTA_PARTITIONS += dtbo boot vendor_boot system system_ext vendor vbmeta product
else
AB_OTA_PARTITIONS += dtbo boot system system_ext vendor vbmeta product
endif
endif

BOARD_DTBOIMG_PARTITION_SIZE := 4194304
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
endif

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE = ext4
TARGET_COPY_OUT_VENDOR := vendor

ifneq ($(IMX_NO_PRODUCT_PARTITION),true)
  BOARD_USES_PRODUCTIMAGE := true
  BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
  TARGET_COPY_OUT_PRODUCT := product
endif

# Build a separate system_ext.img partition
BOARD_USES_SYSTEM_EXTIMAGE := true
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext

BOARD_FLASH_BLOCK_SIZE := 4096

ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  BOARD_SUPER_PARTITION_GROUPS := nxp_dynamic_partitions
  BOARD_SUPER_PARTITION_SIZE := 4294967296
  BOARD_NXP_DYNAMIC_PARTITIONS_SIZE := 4284481536
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    BOARD_NXP_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor
  else
    BOARD_NXP_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor product

  endif
else
  BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
  BOARD_VENDORIMAGE_PARTITION_SIZE := 671088640
  BOARD_SYSTEM_EXTIMAGE_PARTITION_SIZE := 134217728
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2952790016
  else
    BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736

    BOARD_PRODUCTIMAGE_PARTITION_SIZE := 1879048192
  endif
endif

# -------@block_bluetooth-------
BOARD_HAVE_BLUETOOTH := true

# -------@block_camera-------
BOARD_HAVE_IMX_CAMERA := true

# -------@block_display-------
TARGET_GRALLOC_VERSION := v4
TARGET_HWCOMPOSER_VERSION := v2.0

SOONG_CONFIG_IMXPLUGIN_NUM_FRAMEBUFFER_SURFACE_BUFFERS = 3
SOONG_CONFIG_IMXPLUGIN_TARGET_HWCOMPOSER_VERSION = v2.0
SOONG_CONFIG_IMXPLUGIN_TARGET_GRALLOC_VERSION = v4

TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"

TARGET_RECOVERY_UI_LIB := librecovery_ui_imx


# -------@block_gpu-------
# Indicate use vivante drm based egl and gralloc
BOARD_GPU_DRIVERS := vivante

# Indicate use NXP libdrm-imx or Android external/libdrm
BOARD_GPU_LIBDRM := libdrm_imx

PREBUILT_FSL_IMX_GPU := true
SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_GPU = true

# override some prebuilt setting if DISABLE_FSL_PREBUILT is define
ifneq (,$(filter GPU ALL,$(DISABLE_FSL_PREBUILT)))
    PREBUILT_FSL_IMX_GPU := false
    SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_GPU = false
endif

# -------@block_isp-------
#PREBUILT_FSL_IMX_ISP := true
#SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_ISP = true
#
# override some prebuilt setting if DISABLE_FSL_PREBUILT is define
#ifneq (,$(filter ISP ALL,$(DISABLE_FSL_PREBUILT)))
#    PREBUILT_FSL_IMX_ISP := false
#    SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_ISP = false
#endif
#
# -------@block_sensor-------
PREBUILT_FSL_IMX_SENSOR_FUSION := true

# override some prebuilt setting if DISABLE_FSL_PREBUILT is define
ifneq (,$(filter SENSOR_FUSION ALL,$(DISABLE_FSL_PREBUILT)))
    PREBUILT_FSL_IMX_SENSOR_FUSION := false
endif

# -------@block_treble-------
BOARD_VNDK_VERSION := current

# -------@block_multimedia_codec-------

-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/BoardConfig.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/BoardConfig.mk

BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)
