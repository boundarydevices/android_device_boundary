include $(CONFIG_REPO_PATH)/common/build/build_info.mk
# -------@block_infrastructure-------
ifneq ($(IMX8_BUILD_32BIT_ROOTFS),true)
ifneq ($(filter TRUE true 1,$(IMX8_BUILD_64BIT_ROOTFS)),)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif
endif
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
ifneq ($(PRODUCT_HAS_RIL),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_no_telephony.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
endif
ifeq ($(PRODUCT_IMX_CAR),true)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
endif
$(call inherit-product, $(TOPDIR)frameworks/base/data/sounds/AllAudio.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Installs gsi keys into ramdisk.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
PRODUCT_PACKAGES += \
    adb_debug.prop

# -------@block_common_config-------
# overrides
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := boundary

# related to the definition and load of library modules
TARGET_BOARD_PLATFORM := imx

PRODUCT_SHIPPING_API_LEVEL := 34

# -------@block_app-------

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=quicken

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=enforce


# -------@block_multimedia_codec-------

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    Gallery2
endif

# add dmabufheap debug info
PRODUCT_PROPERTY_OVERRIDES += \
    debug.c2.use_dmabufheaps=1

PRODUCT_PACKAGES += \
    vsidaemon \
    CactusPlayer

# Omx related libs
PRODUCT_PACKAGES += \
    lib_aac_dec_v2_arm12_elinux \
    lib_aacd_wrap_arm12_elinux_android \
    lib_mp3_dec_v2_arm12_elinux \
    lib_mp3d_wrap_arm12_elinux_android \
    media_codecs_c2_ac3.xml \
    media_codecs_c2_ddp.xml \
    media_codecs_c2_ms.xml \
    media_codecs_c2_wmv9.xml \
    media_codecs_c2_ra.xml \
    media_codecs_c2_rv.xml \
    media_codecs.xml \
    media_codecs_performance.xml \
    media_profiles_V1_0.xml \
    media_codecs_c2.xml \
    media_codecs_performance_c2.xml

#parser
PRODUCT_PACKAGES += \
    libimxextractor \
    lib_aac_parser_arm11_elinux.3.0 \
    lib_amr_parser_arm11_elinux.3.0 \
    lib_avi_parser_arm11_elinux.3.0 \
    lib_dsf_parser_arm11_elinux.3.0 \
    lib_flac_parser_arm11_elinux.3.0 \
    lib_flv_parser_arm11_elinux.3.0 \
    lib_mkv_parser_arm11_elinux.3.0 \
    lib_mp3_parser_arm11_elinux.3.0 \
    lib_mp4_parser_arm11_elinux.3.0 \
    lib_mpg2_parser_arm11_elinux.3.0 \
    lib_ogg_parser_arm11_elinux.3.0


# Omx excluded libs
PRODUCT_PACKAGES += \
    lib_aacplus_dec_v2_arm11_elinux \
    lib_aacplusd_wrap_arm12_elinux_android \
    lib_ac3_dec_v2_arm11_elinux \
    lib_ac3d_wrap_arm11_elinux_android \
    lib_asf_parser_arm11_elinux.3.0 \
    lib_ddpd_wrap_arm12_elinux_android \
    lib_ddplus_dec_v2_arm12_elinux \
    lib_omx_ac3_dec_v2_arm11_elinux \
    lib_omx_ra_dec_v2_arm11_elinux \
    lib_omx_wma_dec_v2_arm11_elinux \
    lib_omx_wmv_dec_v2_arm11_elinux \
    lib_realad_wrap_arm11_elinux_android \
    lib_realaudio_dec_v2_arm11_elinux \
    lib_rm_parser_arm11_elinux.3.0 \
    lib_wma10_dec_v2_arm12_elinux \
    lib_wma10d_wrap_arm12_elinux_android

# imx c2 codec binary
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.0-service \
    codec2.vendor.base.policy \
    codec2.vendor.ext.policy \
    libsfplugin_ccodec \
    lib_imx_c2_componentbase \
    lib_imx_ts_manager \
    lib_c2_imx_store \
    lib_c2_imx_audio_dec_common \
    lib_c2_imx_aac_dec \
    lib_c2_imx_ac3_dec \
    lib_c2_imx_eac3_dec \
    lib_c2_imx_mp3_dec \
    lib_c2_imx_ra_dec \
    lib_c2_imx_wma_dec

# Set c2 codec in default
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.ccodec=4  \
    debug.stagefright.omx_default_rank=0x200 \
    debug.stagefright.c2-poolmask=0x70000 \
    debug.stagefright.c2inputsurface=-1

-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/fsl_real_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/fsl_ms_codec.mk

PREBUILT_FSL_IMX_CODEC := true

# -------@enable isp copy-------
PREBUILT_FSL_IMX_ISP := true

# -------@block_storage-------

TARGET_USERIMAGES_USE_F2FS := true

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    SystemUpdaterSample

PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/imx8ulp/com.example.android.systemupdatersample.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.example.android.systemupdatersample.xml


# A/B OTA
PRODUCT_PACKAGES += \
    android.hardware.boot-service.default \
    android.hardware.boot-service.default_recovery \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload
else
# non-A/B OTA
PRODUCT_PACKAGES += \
    FSLOta

PRODUCT_COPY_FILES += \
    device/boundary/common/ota/com.fsl.android.ota.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.fsl.android.ota.xml \
    device/boundary/common/ota/ota.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ota.conf
endif

# Support Dynamic partition userspace fastboot
PRODUCT_PACKAGES += \
    fastbootd \

# enable incremental installation
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=1

# enable FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

# health
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery \
    charger_res_images_vendor

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    apexd.config.dm_create.timeout=60000 \
    apexd.config.loop_wait.attempts=99

# -------@block_display-------
ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    CubeLiveWallpapers \
    LiveWallpapersPicker
endif

PRODUCT_PACKAGES += \
    libedid

PRODUCT_PACKAGES += \
    libdrm_android \
    libdisplayutils \
    libfsldisplay

PRODUCT_SOONG_NAMESPACES += external/mesa3d

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.color_saturation=1.0 \
    ro.hw_timeout_multiplier=2

# -------@block_gpu-------
# vivante libdrm support
PRODUCT_PACKAGES += \
    libdrm_vivante

# gpu debug tool
PRODUCT_PACKAGES += \
    gmem_info \
    gpu-top


# -------@block_memtrack-------
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.imx

# -------@block_memory-------
PRODUCT_PACKAGES += \
    libion

# include a google recommand heap config file.
include frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk

# -------@block_security-------
# drm
PRODUCT_PACKAGES += \
    libdrmpassthruplugin \
    libfwdlockengine

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
    $(CONFIG_REPO_PATH)/common/security/testkey

ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    trusty_apploader \

endif

#OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# -------@block_audio-------
PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl:32

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    SoundRecorder
endif

PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
    audio.bluetooth.default \
    audio.primary.imx \
    audio.r_submix.default \
    audio.usb.default \
    tinycap \
    tinymix \
    tinyplay \
    tinypcminfo

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

PRODUCT_VENDOR_PROPERTIES += ro.config.ringtone=Ring_Synth_04.ogg

# -------@block_wifi-------
PRODUCT_PACKAGES += \
    hostapd \
    hostapd_cli \
    wpa_supplicant \
    wpa_cli \

PRODUCT_PACKAGES += \
    mlanutl

PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

ifneq ($(PRODUCT_HAS_RIL),true)
# wifionly device
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=yes
endif

# -------@block_bluetooth-------

PRODUCT_PACKAGES += \
     libbt-vendor

# LDAC codec
PRODUCT_PACKAGES += \
    libldacBT_enc \
    libldacBT_abr

# -------@block_input-------

PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/eGalax_Touch_Screen.idc \
    $(CONFIG_REPO_PATH)/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/ft5x06.idc \
    $(CONFIG_REPO_PATH)/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/silead_ts.idc

# -------@block_profile-------
# In userdebug, add minidebug info the the boot image and the system server to support
# diagnosing native crashes.
ifneq (,$(filter userdebug, $(TARGET_BUILD_VARIANT)))
    # Boot image.
    PRODUCT_DEX_PREOPT_BOOT_FLAGS += --generate-mini-debug-info
    # System server and some of its services.
    # Note: we cannot use PRODUCT_SYSTEM_SERVER_JARS, as it has not been expanded at this point.
    $(call add-product-dex-preopt-module-config,services,--generate-mini-debug-info)
    $(call add-product-dex-preopt-module-config,wifi-service,--generate-mini-debug-info)

    PRODUCT_PROPERTY_OVERRIDES += \
      logd.logpersistd.rotate_kbytes=51200 \
      logd.logpersistd=logcatd \
      logd.logpersistd.size=3
endif

#Dumpstate AIDL support
PRODUCT_PACKAGES += \
    android.hardware.dumpstate-service.imx

# for userdebug or eng build, do not apply the debugfs restrictions
ifneq (,$(filter user, $(TARGET_BUILD_VARIANT)))
    PRODUCT_SET_DEBUGFS_RESTRICTIONS := true
else
    PRODUCT_SET_DEBUGFS_RESTRICTIONS := false
endif

# -------@block_treble-------
# vndservicemanager
PRODUCT_PACKAGES += \
    vndservicemanager

# WiFi regulatory database files
PRODUCT_COPY_FILES += \
    external/wireless-regdb/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/firmware/regulatory.db.p7s \
    external/wireless-regdb/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/firmware/regulatory.db
