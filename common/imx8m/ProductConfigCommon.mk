ifneq ($(IMX8_BUILD_32BIT_ROOTFS),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
ifeq ($(PRODUCT_IMX_CAR),true)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
endif
$(call inherit-product, $(TOPDIR)frameworks/base/data/sounds/AllAudio.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
# overrides
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := freescale

# Android infrastructures
PRODUCT_PACKAGES += \
    CactusPlayer \
    ExtractorPkg \
    charger_res_images \
    ethernet \
    libGLES_android \
    libRS \
    libedid \
    libion \
    librs_jni \
    slideshow \
    verity_warning_images \
    vndk-sp

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    Camera \
    CubeLiveWallpapers \
    Email \
    Gallery2 \
    LegacyCamera \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    SoundRecorder
endif

# HAL
PRODUCT_PACKAGES += \
    copybit.imx \
    gralloc.imx \
    hwcomposer.imx \
    lights.imx \
    overlay.imx \
    power.imx

PRODUCT_STATIC_BOOT_CONTROL_HAL:= \
    bootctrl-static.avb \
    libcutils \

ifeq ($(AB_OTA_UPDATER),true)
# A/B OTA
PRODUCT_PACKAGES += \
    SystemUpdaterSample \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    bootctrl.avb \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

PRODUCT_COPY_FILES += \
    device/boundary/common/imx8m/com.example.android.systemupdatersample.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.example.android.systemupdatersample.xml
else
# non-A/B OTA
PRODUCT_PACKAGES += \
    FSLOta

PRODUCT_COPY_FILES += \
    device/boundary/common/ota/com.fsl.android.ota.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.fsl.android.ota.xml \
    device/boundary/common/ota/ota.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ota.conf
endif

# audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.imx \
    audio.r_submix.default \
    audio.usb.default \
    libaudioutils \
    libsrec_jni \
    libtinyalsa \
    tinycap \
    tinymix \
    tinyplay

# LDAC codec
PRODUCT_PACKAGES += \
    libldacBT_enc \
    libldacBT_abr

# wifi
PRODUCT_PACKAGES += \
    hostapd \
    hostapd_cli \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

# sensor
PRODUCT_PACKAGES += \
    fsl_sensor_fusion \
    libbt-vendor \
    magd

# memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    memtrack.imx

# camera
ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    camera.device@1.0-impl \
    camera.device@3.2-impl \
    camera.imx
endif

PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.imx

# display
PRODUCT_PACKAGES += \
    libdrm_android \
    libfsldisplay \
    nxp.hardware.display@1.0

# drm
PRODUCT_PACKAGES += \
    drmserver                   		\
    libdrmframework             		\
    libdrmframework_jni         		\
    libdrmpassthruplugin        		\
    libfwdlockengine

# vivante libdrm support
PRODUCT_PACKAGES += \
    libdrm_vivante

# FUSE based emulated sdcard daemon
PRODUCT_PACKAGES += \
    sdcard

# e2fsprogs libs
PRODUCT_PACKAGES += \
    libext2_blkid \
    libext2_com_err \
    libext2_e2p \
    libext2_profile \
    libext2_uuid \
    libext2fs \
    mke2fs

# for CtsVerifier
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# gpu debug tool
PRODUCT_PACKAGES += \
    gmem_info \
    gpu-top

# Omx related libs, please align to device/boundary/proprietary/omx/fsl-omx.mk
PRODUCT_PACKAGES += \
    lib_aac_dec_v2_arm12_elinux \
    lib_aacd_wrap_arm12_elinux_android \
    lib_flac_dec_v2_arm11_elinux \
    lib_mp3_dec_v2_arm12_elinux \
    lib_mp3_enc_v2_arm12_elinux \
    lib_mp3d_wrap_arm12_elinux_android \
    lib_nb_amr_dec_v2_arm9_elinux \
    lib_nb_amr_enc_v2_arm11_elinux \
    lib_peq_v2_arm11_elinux \
    lib_wb_amr_dec_arm9_elinux \
    lib_wb_amr_enc_arm11_elinux \
    libfsl_jpeg_enc_arm11_elinux \
    media_codecs_c2_ac3.xml \
    media_codecs_c2_ddp.xml \
    media_codecs_c2_ms.xml \
    media_codecs_c2_wmv9.xml \
    media_codecs_c2_ra.xml \
    media_codecs_c2_rv.xml \
    media_codecs_performance.xml \
    media_profiles_V1_0.xml \
    media_codecs_google_c2_video.xml \
    media_codecs_c2.xml \
    media_codecs_performance_c2.xml

PRODUCT_PACKAGES += \
    media_codecs.xml

#parser
PRODUCT_PACKAGES += \
    libimxextractor \
    lib_aac_parser_arm11_elinux.3.0 \
    lib_amr_parser_arm11_elinux.3.0 \
    lib_ape_parser_arm11_elinux.3.0 \
    lib_avi_parser_arm11_elinux.3.0 \
    lib_dsf_parser_arm11_elinux.3.0 \
    lib_flac_parser_arm11_elinux.3.0 \
    lib_flv_parser_arm11_elinux.3.0 \
    lib_mkv_parser_arm11_elinux.3.0 \
    lib_mp3_parser_arm11_elinux.3.0 \
    lib_mp4_parser_arm11_elinux.3.0 \
    lib_mpg2_parser_arm11_elinux.3.0 \
    lib_ogg_parser_arm11_elinux.3.0 \
    lib_wav_parser_arm11_elinux.3.0 \

# Omx excluded libs
PRODUCT_PACKAGES += \
    lib_WMV789_dec_v2_arm11_elinux \
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
    lib_c2_imx_wma_dec \

# Support Dynamic partition userspace fastboot
PRODUCT_PACKAGES += \
    fastbootd \

# Copy soc related config and binary to board
PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_c2_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_telephony.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_c2_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_tv.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_profiles_720p.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_720p.xml \
    device/boundary/common/imx8m/init.recovery.freescale.rc:root/init.recovery.freescale.rc \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=quicken \
    ro.hardware.bootctrl=avb \

# wifionly device
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=yes

PRODUCT_PROPERTY_OVERRIDES += \
    ro.mediacomponents.package=com.nxp.extractorpkg

# Freescale multimedia parser related prop setting
# Define fsl avi/aac/asf/mkv/flv/flac format support
PRODUCT_PROPERTY_OVERRIDES += \
    ro.FSL_AVI_PARSER=1 \
    ro.FSL_AAC_PARSER=1 \
    ro.FSL_FLV_PARSER=1 \
    ro.FSL_MKV_PARSER=1 \
    ro.FSL_FLAC_PARSER=1 \
    ro.FSL_MPG2_PARSER=1

# Set c2 codec in default
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.ccodec=4  \
    debug.stagefright.omx_default_rank=0x200 \
    debug.stagefright.c2-poolmask=0x70000

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
    device/boundary/common/security/testkey

# In userdebug, add minidebug info the the boot image and the system server to support
# diagnosing native crashes.
ifneq (,$(filter userdebug, $(TARGET_BUILD_VARIANT)))
    # Boot image.
    PRODUCT_DEX_PREOPT_BOOT_FLAGS += --generate-mini-debug-info
    # System server and some of its services.
    # Note: we cannot use PRODUCT_SYSTEM_SERVER_JARS, as it has not been expanded at this point.
    $(call add-product-dex-preopt-module-config,services,--generate-mini-debug-info)
    $(call add-product-dex-preopt-module-config,wifi-service,--generate-mini-debug-info)
endif

PRODUCT_AAPT_CONFIG := normal mdpi

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=enforce

# include a google recommand heap config file.
include frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk

-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/fsl_real_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/fsl_ms_codec.mk

PREBUILT_FSL_IMX_CODEC := true
