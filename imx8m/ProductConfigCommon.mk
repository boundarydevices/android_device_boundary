$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
ifeq ($(PRODUCT_IMX_CAR),true)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
endif
$(call inherit-product, $(TOPDIR)frameworks/base/data/sounds/AllAudio.mk)
# overrides
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := freescale

# Android infrastructures
PRODUCT_PACKAGES += \
    CactusPlayer \
    FSLOta \
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
    copybit.imx8 \
    gralloc.imx8 \
    hwcomposer.imx8 \
    lights.imx8 \
    overlay.imx8 \
    power.imx8

# A/B OTA
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    bootctrl.avb \
    brillo_update_payload \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier

# audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.imx8 \
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

# sensor
PRODUCT_PACKAGES += \
    fsl_sensor_fusion \
    libbt-vendor \
    magd

# memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    memtrack.imx8

# camera
ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    camera.device@1.0-impl \
    camera.device@3.2-impl \
    camera.imx8
endif

PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.imx

# display
PRODUCT_PACKAGES += \
    libdrm_android \
    libfsldisplay

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

# Omx related libs, please align to device/fsl/proprietary/omx/fsl-omx.mk
PRODUCT_PACKAGES += \
    ComponentRegistry.txt \
    component_register \
    contentpipe_register \
    core_register \
    fslomx.cfg \
    lib_aac_dec_v2_arm12_elinux \
    lib_aac_parser_arm11_elinux \
    lib_aac_parser_arm11_elinux.3.0 \
    lib_aacd_wrap_arm12_elinux_android \
    lib_amr_parser_arm11_elinux.3.0 \
    lib_ape_parser_arm11_elinux.3.0 \
    lib_avi_parser_arm11_elinux.3.0 \
    lib_divx_drm_arm11_elinux \
    lib_dsf_parser_arm11_elinux.3.0 \
    lib_ffmpeg_arm11_elinux \
    lib_flac_dec_v2_arm11_elinux \
    lib_flac_parser_arm11_elinux \
    lib_flac_parser_arm11_elinux.3.0 \
    lib_flv_parser_arm11_elinux.3.0 \
    lib_id3_parser_arm11_elinux \
    lib_mkv_parser_arm11_elinux.3.0 \
    lib_mp3_dec_v2_arm12_elinux \
    lib_mp3_enc_v2_arm12_elinux \
    lib_mp3_parser_arm11_elinux.3.0 \
    lib_mp3_parser_v2_arm11_elinux \
    lib_mp3d_wrap_arm12_elinux_android \
    lib_mp4_muxer_arm11_elinux \
    lib_mp4_parser_arm11_elinux.3.0 \
    lib_mpg2_parser_arm11_elinux.3.0 \
    lib_nb_amr_dec_v2_arm9_elinux \
    lib_nb_amr_enc_v2_arm11_elinux \
    lib_ogg_parser_arm11_elinux.3.0 \
    lib_oggvorbis_dec_v2_arm11_elinux \
    lib_omx_aac_dec_v2_arm11_elinux \
    lib_omx_aac_enc_v2_arm11_elinux \
    lib_omx_aac_parser_v2_arm11_elinux \
    lib_omx_ac3toiec937_arm11_elinux \
    lib_omx_amr_dec_v2_arm11_elinux \
    lib_omx_amr_enc_v2_arm11_elinux \
    lib_omx_android_audio_render_arm11_elinux \
    lib_omx_android_audio_source_arm11_elinux \
    lib_omx_async_write_pipe_arm11_elinux \
    lib_omx_audio_fake_render_arm11_elinux \
    lib_omx_audio_processor_v2_arm11_elinux \
    lib_omx_bsac_dec_v2_arm11_elinux \
    lib_omx_camera_source_arm11_elinux \
    lib_omx_client_arm11_elinux \
    lib_omx_clock_v2_arm11_elinux \
    lib_omx_common_v2_arm11_elinux \
    lib_omx_core_mgr_v2_arm11_elinux \
    lib_omx_core_v2_arm11_elinux \
    lib_omx_ec3_dec_v2_arm11_elinux \
    lib_omx_flac_dec_v2_arm11_elinux \
    lib_omx_flac_parser_v2_arm11_elinux \
    lib_omx_fsl_muxer_v2_arm11_elinux \
    lib_omx_fsl_parser_v2_arm11_elinux \
    lib_omx_https_pipe_arm11_elinux \
    lib_omx_https_pipe_v2_arm11_elinux \
    lib_omx_https_pipe_v3_arm11_elinux \
    lib_omx_ipulib_render_arm11_elinux \
    lib_omx_libav_audio_dec_arm11_elinux \
    lib_omx_libav_video_dec_arm11_elinux \
    lib_omx_local_file_pipe_v2_arm11_elinux \
    lib_omx_mp3_dec_v2_arm11_elinux \
    lib_omx_mp3_enc_v2_arm11_elinux \
    lib_omx_mp3_parser_v2_arm11_elinux \
    lib_omx_osal_v2_arm11_elinux \
    lib_omx_overlay_render_arm11_elinux \
    lib_omx_pcm_dec_v2_arm11_elinux \
    lib_omx_player_arm11_elinux \
    lib_omx_res_mgr_v2_arm11_elinux \
    lib_omx_rtps_pipe_arm11_elinux \
    lib_omx_shared_fd_pipe_arm11_elinux \
    lib_omx_soft_hevc_dec_arm11_elinux \
    lib_omx_sorenson_dec_v2_arm11_elinux \
    lib_omx_streaming_parser_arm11_elinux \
    lib_omx_surface_render_arm11_elinux \
    lib_omx_surface_source_arm11_elinux \
    lib_omx_tunneled_decoder_arm11_elinux \
    lib_omx_udps_pipe_arm11_elinux \
    lib_omx_utils_v2_arm11_elinux \
    lib_omx_vorbis_dec_v2_arm11_elinux \
    lib_omx_vpu_dec_v2_arm11_elinux \
    lib_omx_vpu_enc_v2_arm11_elinux \
    lib_omx_vpu_v2_arm11_elinux \
    lib_omx_wav_parser_v2_arm11_elinux \
    lib_peq_v2_arm11_elinux \
    lib_vorbisd_wrap_arm11_elinux_android \
    lib_vpu_wrapper \
    lib_wav_parser_arm11_elinux \
    lib_wav_parser_arm11_elinux.3.0 \
    lib_wb_amr_dec_arm9_elinux \
    lib_wb_amr_enc_arm11_elinux \
    libavcodec \
    libavutil \
    libfsl_jpeg_enc_arm11_elinux \
    libfslextractor \
    libfslxec \
    libstagefrighthw \
    libswresample \
    libxec \
    media_codecs.xml \
    media_codecs_performance.xml \
    media_profiles_V1_0.xml

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
    lib_dsp_aac_dec \
    lib_dsp_bsac_dec \
    lib_dsp_codec_wrap \
    lib_dsp_mp3_dec \
    lib_dsp_wrap_arm12_android \
    lib_omx_ac3_dec_v2_arm11_elinux \
    lib_omx_ra_dec_v2_arm11_elinux \
    lib_omx_wma_dec_v2_arm11_elinux \
    lib_omx_wmv_dec_v2_arm11_elinux \
    lib_realad_wrap_arm11_elinux_android \
    lib_realaudio_dec_v2_arm11_elinux \
    lib_rm_parser_arm11_elinux.3.0 \
    lib_wma10_dec_v2_arm12_elinux \
    lib_wma10d_wrap_arm12_elinux_android

# Copy soc related config and binary to board
PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media_profiles_720p.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_720p.xml \
    device/fsl/common/input/Dell_Dell_USB_Entry_Keyboard.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Dell_Dell_USB_Entry_Keyboard.idc \
    device/fsl/common/input/Dell_Dell_USB_Keyboard.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Dell_Dell_USB_Keyboard.idc \
    device/fsl/common/input/Dell_Dell_USB_Keyboard.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Dell_Dell_USB_Keyboard.kl \
    device/fsl/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/HannStar_P1003_Touchscreen.idc \
    device/fsl/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Novatek_NT11003_Touch_Screen.idc \
    device/fsl/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/eGalax_Touch_Screen.idc \
    device/fsl/imx8m/etc/ota.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ota.conf \
    device/fsl/imx8m/init.recovery.freescale.rc:root/init.recovery.freescale.rc \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    system/core/rootdir/init.rc:root/init.rc

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=quicken \
    ro.hardware.bootctrl=avb \

# wifionly device
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=yes

# Freescale multimedia parser related prop setting
# Define fsl avi/aac/asf/mkv/flv/flac format support
PRODUCT_PROPERTY_OVERRIDES += \
    ro.FSL_AVI_PARSER=1 \
    ro.FSL_AAC_PARSER=1 \
    ro.FSL_FLV_PARSER=1 \
    ro.FSL_MKV_PARSER=1 \
    ro.FSL_FLAC_PARSER=1 \
    ro.FSL_MPG2_PARSER=1

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
    device/fsl/common/security/testkey

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

# include a google recommand heap config file.
include frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk

-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/fsl_real_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/fsl_ms_codec.mk
