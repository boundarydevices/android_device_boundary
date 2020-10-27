IMX_DEVICE_PATH := device/boundary/nitrogen8mp

# configs shared between uboot, kernel and Android rootfs
include $(IMX_DEVICE_PATH)/SharedBoardConfig.mk

-include device/boundary/common/imx_path/ImxPathConfig.mk
include device/boundary/common/imx8m/ProductConfigCommon.mk

# Overrides
PRODUCT_NAME := nitrogen8mp
PRODUCT_DEVICE := nitrogen8mp
PRODUCT_MODEL := NITROGEN8MP

PRODUCT_FULL_TREBLE_OVERRIDE := true

# Include keystore attestation keys and certificates.
ifeq ($(PRODUCT_IMX_TRUSTY),true)
-include $(IMX_SECURITY_PATH)/attestation/imx_attestation.mk
endif

# Include Android Go config for low memory device.
ifeq ($(LOW_MEMORY),true)
$(call inherit-product, build/target/product/go_defaults.mk)
endif

# Copy device related config and binary to board
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml \
    $(IMX_DEVICE_PATH)/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(IMX_DEVICE_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(IMX_DEVICE_PATH)/usb_audio_policy_configuration-direct-output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration-direct-output.xml \
    $(IMX_DEVICE_PATH)/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml \
    $(IMX_DEVICE_PATH)/fstab.freescale:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.freescale \
    $(IMX_DEVICE_PATH)/init.imx8mp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.imx8mp.rc \
    $(IMX_DEVICE_PATH)/init.recovery.freescale.rc:root/init.recovery.freescale.rc \
    $(IMX_DEVICE_PATH)/early.init.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/early.init.cfg \
    $(IMX_DEVICE_PATH)/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.rc \
    $(IMX_DEVICE_PATH)/init.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.usb.rc \
    $(IMX_DEVICE_PATH)/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml \
    $(IMX_DEVICE_PATH)/ueventd.freescale.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/sdma/sdma-imx7d.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/imx/sdma/sdma-imx7d.bin \
    device/boundary/common/init/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh \
    device/boundary/common/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    device/boundary/common/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# Copy isp files to board
ISP_PROPRIETARY := $(FSL_PROPRIETARY_PATH)/fsl-proprietary/isp
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(ISP_PROPRIETARY)/bin,$(TARGET_COPY_OUT_VENDOR)/bin) \
    $(call find-copy-subdir-files,*,$(ISP_PROPRIETARY)/lib64,$(TARGET_COPY_OUT_VENDOR)/lib64) \
    $(call find-copy-subdir-files,*,$(ISP_PROPRIETARY)/config,$(TARGET_COPY_OUT_VENDOR)/etc/configs/isp)

# Audio card json
PRODUCT_COPY_FILES += \
    device/fsl/common/audio-json/wm8960_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/wm8960_config.json \
    device/fsl/common/audio-json/micfil_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/micfil_config.json \
    device/fsl/common/audio-json/hdmi_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/hdmi_config.json \

ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_COPY_FILES += \
    device/boundary/common/security/rpmb_key_test.bin:rpmb_key_test.bin \
    device/boundary/common/security/testkey_public_rsa4096.bin:testkey_public_rsa4096.bin
endif

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/camera_config_imx8mp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/camera_config_imx8mp.json \
    $(IMX_DEVICE_PATH)/ov5640_camera_config_imx8mp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/ov5640_camera_config_imx8mp.json \
    $(IMX_DEVICE_PATH)/isp_camera_config_imx8mp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/isp_camera_config_imx8mp.json

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
    $(IMX_DEVICE_PATH)/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/powerhint_imx8mp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/powerhint_imx8mp.json

USE_XML_AUDIO_POLICY_CONF := 1

DEVICE_PACKAGE_OVERLAYS := \
    $(IMX_DEVICE_PATH)/overlay \
    device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi xxhdpi

# GPU openCL g2d
PRODUCT_COPY_FILES += \
    $(IMX_PATH)/imx/opencl-2d/cl_g2d.cl:$(TARGET_COPY_OUT_VENDOR)/etc/cl_g2d.cl

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.3-service

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
    libEGL_VIVANTE \
    libGLESv1_CM_VIVANTE \
    libGLESv2_VIVANTE \
    gralloc_viv.imx \
    libGAL \
    libGLSLC \
    libVSC \
    libgpuhelper \
    libSPIRV_viv \
    libvulkan_VIVANTE \
    vulkan.imx \
    libCLC \
    libLLVM_viv \
    libOpenCL \
    libg2d-opencl \
    libg2d-viv \
    libOpenVX \
    libOpenVXU \
    libNNVXCBinary-evis \
    libNNVXCBinary-evis2 \
    libNNVXCBinary-lite \
    libOvx12VXCBinary-evis \
    libOvx12VXCBinary-evis2 \
    libOvx12VXCBinary-lite \
    libNNGPUBinary-evis \
    libNNGPUBinary-evis2 \
    libNNGPUBinary-lite \
    libNNGPUBinary-ulite \
    libNNArchPerf \
    libarchmodelSw \
    gatekeeper.imx

PRODUCT_PACKAGES += \
    android.hardware.audio@5.0-impl:32 \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@5.0-impl:32 \
    android.hardware.power@1.3-service.imx \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.1-service \
    configstore@1.1.policy

# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.imx
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8mp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8mp.json

# Neural Network HAL and lib
PRODUCT_PACKAGES += \
    libovxlib \
    libnnrt \
    android.hardware.neuralnetworks@1.2-service-vsi-npu-server

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.imx

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wifilogd \
    wificond

PRODUCT_PACKAGES += \
    bdwlan30.bin \
    cfg.dat \
    otp30.bin \
    qcom_cfg.ini \
    qwlan30.bin \
    tfbtfw11.tlv \
    tfbtnv11.bin

BOARD_CUSTOM_BT_CONFIG := $(IMX_DEVICE_PATH)/bluetooth/libbt_vnd.conf

# hardware backed keymaster service
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-service.trusty
endif

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# DRM HAL
TARGET_ENABLE_MEDIADRM_64 := true
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=28

PRODUCT_PACKAGES += \
    libg1 \
    libhantro \
    libcodec \
    libhantro_vc8000e

# imx c2 codec binary
PRODUCT_PACKAGES += \
    lib_vpu_wrapper \
    lib_imx_c2_videodec_common \
    lib_imx_c2_videodec \
    lib_imx_c2_vpuwrapper_dec \
    lib_imx_c2_videoenc_common \
    lib_imx_c2_videoenc \
    lib_imx_c2_vpuwrapper_enc \
    lib_imx_c2_process \
    lib_imx_c2_process_dummy_post \
    lib_imx_c2_process_g2d_pre \
    c2_component_register \
    c2_component_register_ms \
    c2_component_register_ra

# dsp decoder
PRODUCT_PACKAGES += \
    media_codecs_c2_dsp.xml \
    media_codecs_c2_dsp_aacp.xml \
    media_codecs_c2_dsp_wma.xml \
    lib_dsp_aac_dec \
    lib_dsp_bsac_dec \
    lib_dsp_codec_wrap \
    lib_dsp_mp3_dec \
    lib_dsp_wrap_arm12_android \
    lib_dsp_mp3_dec_ext \
    lib_dsp_codec_wrap_ext \
    lib_aacd_wrap_dsp \
    lib_mp3d_wrap_dsp \
    lib_wma10d_wrap_dsp \
    c2_component_register_dsp \
    c2_component_register_dsp_wma \
    c2_component_register_dsp_aacp


PRODUCT_PACKAGES += \
    DirectAudioPlayer

# Tensorflow lite camera demo
PRODUCT_PACKAGES += \
    tflitecamerademo

# Multi-Display launcher
PRODUCT_PACKAGES += \
    MultiDisplay

# Add oem unlocking option in settings.
PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/frp
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# Add Trusty OS backed gatekeeper and secure storage proxy
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    gatekeeper.trusty \
    storageproxyd
endif

#DRM Widevine 1.2 L3 support
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.2-service.widevine \
    android.hardware.drm@1.2-service.clearkey \
    libwvdrmcryptoplugin \
    libwvhidl \
    libwvdrmengine \

#Dumpstate HAL 1.0 support
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.imx

ifeq ($(PRODUCT_IMX_TRUSTY),true)
#Oemlock HAL 1.0 support
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0-service.imx
endif

# Specify rollback index for bootloader and for AVB
ifneq ($(AVB_RBINDEX),)
BOARD_AVB_ROLLBACK_INDEX := $(AVB_RBINDEX)
else
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
PRODUCT_PACKAGES += \
    adb_debug.prop
endif

IMX-DEFAULT-G2D-LIB := libg2d-opencl

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
ifneq ($(IMX8_BUILD_32BIT_ROOTFS),true)
INSTALL_64BIT_LIBRARY := true
endif
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_aacp_dec/imx_dsp_aacp_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_codec/imx_dsp_codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_wma_dec/imx_dsp_wma_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp/imx_dsp_8mp.mk
endif

# Input configuration
PRODUCT_COPY_FILES += \
    device/boundary/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/EETI_eGalax_Touch_Screen.idc \
    device/boundary/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/ft5x06.idc \
    device/boundary/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/silead_ts.idc
