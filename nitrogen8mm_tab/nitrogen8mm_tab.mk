# -------@block_infrastructure-------

CONFIG_REPO_PATH := device/boundary
CURRENT_FILE_PATH :=  $(lastword $(MAKEFILE_LIST))
IMX_DEVICE_PATH := $(strip $(patsubst %/, %, $(dir $(CURRENT_FILE_PATH))))

PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := true

# configs shared between uboot, kernel and Android rootfs
include $(IMX_DEVICE_PATH)/SharedBoardConfig.mk
-include vendor/quectel/ec2x/ril-quectel.mk
-include hardware/invensense/firmware/device-invn.mk
-include $(CONFIG_REPO_PATH)/common/imx_path/ImxPathConfig.mk
include $(CONFIG_REPO_PATH)/common/imx8m/ProductConfigCommon.mk

# -------@block_common_config-------

# Overrides
PRODUCT_NAME := nitrogen8mm_tab
PRODUCT_DEVICE := nitrogen8mm_tab
PRODUCT_MODEL := NITROGEN8MM_TAB

TARGET_BOOTLOADER_BOARD_NAME := nitrogen

PRODUCT_CHARACTERISTICS := tablet

DEVICE_PACKAGE_OVERLAYS := \
    $(IMX_DEVICE_PATH)/overlay \
    device/boundary/common/overlay

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

PRODUCT_VENDOR_PROPERTIES += ro.soc.manufacturer=boundary
PRODUCT_VENDOR_PROPERTIES += ro.soc.model=IMX8MM
# -------@block_treble-------
PRODUCT_FULL_TREBLE_OVERRIDE := true

# -------@block_power-------
PRODUCT_SOONG_NAMESPACES += vendor/nxp-opensource/imx/power
PRODUCT_SOONG_NAMESPACES += hardware/google/pixel

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/powerhint_imx8mm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/powerhint_imx8mm.json

# Charger Mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.no_ui=false

# Do not skip charger_not_need trigger by default
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    vendor.skip.charger_not_need=0

PRODUCT_PACKAGES += \
    android.hardware.power-service.imx

# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.imx

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8mm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8mm.json

# Task Profiles
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json


# -------@block_app-------

#Enable this to choose 32 bit user space build
IMX8_BUILD_32BIT_ROOTFS := false

# Set permission for GMS packages
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/imx8m/permissions/privapp-permissions-imx.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp.permissions-imx.xml

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

# -------@block_kernel_bootimg-------

# Enable this to support vendor boot and boot header v3, this would be a MUST for GKI
TARGET_USE_VENDOR_BOOT ?= false

ifeq ($(IMX8MM_USES_GKI),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.gki.enable=true

BOARD_RAMDISK_USE_LZ4 := true

BOARD_USES_GENERIC_KERNEL_IMAGE := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
endif

# We load the fstab from device tree so this is not needed, but since no kernel modules are installed to vendor
# boot ramdisk so far, we need this step to generate the vendor-ramdisk folder or build process would fail. This
# can be deleted once we figure out what kernel modules should be put into the vendor boot ramdisk.
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/fstab.nxp:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.nxp
endif

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/early.init.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/early.init.cfg \
    $(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/sdma/sdma-imx7d.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/firmware/imx/sdma/sdma-imx7d.bin \
    $(CONFIG_REPO_PATH)/common/init/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh \
    $(IMX_DEVICE_PATH)/ueventd.nxp.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# -------@block_storage-------

# support metadata checksum during first stage mount
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
PRODUCT_PACKAGES += \
    linker.vendor_ramdisk \
    resizefs.vendor_ramdisk \
    tune2fs.vendor_ramdisk
endif

#Enable this to use dynamic partitions for the readonly partitions not touched by bootloader
TARGET_USE_DYNAMIC_PARTITIONS ?= false

ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  ifeq ($(TARGET_USE_VENDOR_BOOT),true)
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
  else
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
  endif
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
  BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true
endif

#Enable this to disable product partition build.
IMX_NO_PRODUCT_PARTITION := true

$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)


PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/fstab.nxp:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.nxp

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.nxp

ifneq ($(filter TRUE true 1,$(IMX_OTA_POSTINSTALL)),)
  PRODUCT_PACKAGES += imx_ota_postinstall

  AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/imx_ota_postinstall \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=false

  PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/u-boot-imx8mm-trusty.imx:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
endif

# -------@block_security-------

# Include keystore attestation keys and certificates.
ifeq ($(PRODUCT_IMX_TRUSTY),true)
-include $(IMX_SECURITY_PATH)/attestation/imx_attestation.mk
endif


ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/security/rpmb_key_test.bin:rpmb_key_test.bin \
    $(CONFIG_REPO_PATH)/common/security/testkey_public_rsa4096.bin:testkey_public_rsa4096.bin
endif

# Keymaster HAL
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service.trusty
endif

PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service-imx

# Confirmation UI
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.confirmationui@1.0-service.trusty
endif

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software-imx

# Add Trusty OS backed gatekeeper and secure storage proxy
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.trusty \
    storageproxyd
endif

# Add oem unlocking option in settings.
PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/frp

ifeq ($(PRODUCT_IMX_TRUSTY),true)
#Oemlock HAL 1.0 support
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0-service.imx
endif

# Specify rollback index for boot and vbmeta partition
ifneq ($(AVB_RBINDEX),)
BOARD_AVB_ROLLBACK_INDEX := $(AVB_RBINDEX)
else
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifneq ($(AVB_BOOT_RBINDEX),)
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(AVB_BOOT_RBINDEX)
else
BOARD_AVB_BOOT_ROLLBACK_INDEX := 0
endif

$(call  inherit-product-if-exists, vendor/nxp-private/security/nxp_security.mk)

# Resume on Reboot support
PRODUCT_PACKAGES += \
    android.hardware.rebootescrow-service.default

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rebootescrow.device=/dev/block/pmem0

#DRM Widevine 1.2 L3 support
PRODUCT_PACKAGES += \
    android.hardware.drm@1.3-service.widevine \
    android.hardware.drm@1.3-service.clearkey \
    libwvdrmcryptoplugin \
    libwvhidl \
    libwvdrmengine

# -------@block_audio-------

# Audio card json
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/audio-json/wm8960_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/wm8960_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/spdif_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/spdif_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/micfil_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/micfil_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/btsco_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/btsco_config.json \

PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8mm/imx8mm_mcu_demo.img:imx8mm_mcu_demo.img \
    $(IMX_DEVICE_PATH)/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(IMX_DEVICE_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(IMX_DEVICE_PATH)/usb_audio_policy_configuration-direct-output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration-direct-output.xml


# -------@block_camera-------
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/camera_config_imx8mm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/camera_config_imx8mm.json \
    $(IMX_DEVICE_PATH)/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_SOONG_NAMESPACES += hardware/google/camera
PRODUCT_SOONG_NAMESPACES += vendor/nxp-opensource/imx/camera

# -------@block_display-------

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi xxhdpi

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service

# define frame buffer count
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl.imx \
    android.hardware.graphics.allocator@4.0-service.imx

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# -------@block_gpu-------

PRODUCT_PACKAGES += \
    libEGL_VIVANTE \
    libGLESv1_CM_VIVANTE \
    libGLESv2_VIVANTE \
    gralloc_viv.$(TARGET_BOARD_PLATFORM) \
    libGAL \
    libGLSLC \
    libVSC \
    libCLC \
    libLLVM_viv \
    libOpenCL \
    libg2d-viv \
    libgpuhelper \


# -------@block_wifi-------

# wifi supplicant overlay
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(CONFIG_REPO_PATH)/common/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wificond

# WiFi RRO
PRODUCT_PACKAGES += \
    bdwlan30.bin \
    cfg.dat \
    otp30.bin \
    qcom_cfg.ini \
    qwlan30.bin \
    tfbtfw11.tlv \
    tfbtnv11.bin

# -------@block_bluetooth-------

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

BOARD_CUSTOM_BT_CONFIG := $(IMX_DEVICE_PATH)/bluetooth/libbt_vnd.conf

# -------@block_usb-------

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.imx

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.usb.rc

# -------@block_multimedia_codec-------

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
    $(IMX_DEVICE_PATH)/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy \
    $(CONFIG_REPO_PATH)/common/seccomp_policy/codec2.vendor.base.policy:vendor/etc/seccomp_policy/codec2.vendor.base.policy \
    $(CONFIG_REPO_PATH)/common/seccomp_policy/codec2.vendor.ext.policy:vendor/etc/seccomp_policy/codec2.vendor.ext.policy

PRODUCT_PACKAGES += \
    libg1 \
    libhantro \
    libcodec \
    libhantro_h1 \
    libcodec_enc \
    DirectAudioPlayer

# imx c2 codec binary
PRODUCT_PACKAGES += \
    lib_vpu_wrapper \
    lib_imx_c2_videodec \
    lib_imx_c2_vpuwrapper_dec \
    lib_imx_c2_videodec_common \
    lib_imx_c2_videoenc_common \
    lib_imx_c2_vpuwrapper_enc \
    lib_imx_c2_videoenc \
    lib_imx_c2_process \
    lib_imx_c2_process_dummy_post \
    lib_imx_c2_process_g2d_pre \
    c2_component_register \
    c2_component_register_ms \
    c2_component_register_ra

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
ifneq ($(IMX8_BUILD_32BIT_ROOTFS),true)
INSTALL_64BIT_LIBRARY := true
endif
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

# -------@block_memory-------

# Include Android Go config for low memory device.
ifeq ($(LOW_MEMORY),true)
  $(call inherit-product, build/target/product/go_defaults.mk)
endif

# -------@block_miscellaneous-------

# Copy device related config and binary to board
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.imx8mm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.imx8mm.rc \
    $(IMX_DEVICE_PATH)/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.rc \
    $(IMX_DEVICE_PATH)/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml

ifeq ($(TARGET_USE_VENDOR_BOOT),true)
  PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.recovery.nxp.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.nxp.rc
else
  PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.recovery.nxp.rc:root/init.recovery.nxp.rc
endif

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.external.xml:vendor/etc/permissions/android.hardware.camera.external.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml

# trusty loadable apps
PRODUCT_COPY_FILES += \
    vendor/nxp/fsl-proprietary/uboot-firmware/imx8m/confirmationui.app:/vendor/firmware/tee/confirmationui.app

# Included GMS package
$(call inherit-product-if-exists, vendor/partner_gms/products/gms.mk)
PRODUCT_SOONG_NAMESPACES += vendor/partner_gms

# libgpiod tools
PRODUCT_PACKAGES += \
    gpiodetect \
    gpiofind \
    gpioget \
    gpioinfo \
    gpiomon \
    gpioset

# PN7150 config files
NXP_NFC_HOST := $(TARGET_PRODUCT)
NXP_NFC_HW := pn7150
NXP_NFC_PLATFORM := pn54x
NXP_VENDOR_DIR := nxp

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:system/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \

# NFC config files
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/nfc/libnfc-nci.conf:system/etc/libnfc-nci.conf \
    $(IMX_DEVICE_PATH)/nfc/libnfc-nxp.conf:vendor/etc/libnfc-nxp.conf

# NFC packages
PRODUCT_PACKAGES += \
    libnfc-nci \
    NfcNci \
    Tag \
    android.hardware.nfc@1.0-impl \
    nfc_nci.$(NXP_NFC_PLATFORM) \

# NFC HAL services
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.2-service \
    vendor.nxp.nxpnfc@1.0-impl \
    vendor.nxp.nxpnfc@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.nfc_nci=$(NXP_NFC_PLATFORM)
