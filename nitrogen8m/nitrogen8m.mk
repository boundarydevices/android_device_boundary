-include device/fsl/common/imx_path/ImxPathConfig.mk

# Disable Android Verified Boot for now
BOARD_AVB_ENABLE := false
PRODUCT_FULL_TREBLE_OVERRIDE := false

$(call inherit-product, device/fsl/imx8/imx8.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nitrogen8m
PRODUCT_DEVICE := nitrogen8m
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary
KERNEL_IMX_PATH := vendor/boundary
UBOOT_IMX_PATH := vendor/boundary
IMX_MKIMAGE_PATH := vendor/boundary

# Audio
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	device/boundary/common/audio_effects.conf:vendor/etc/audio_effects.conf \
	device/boundary/common/audio_policy_configuration.xml:vendor/etc/audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:vendor/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:vendor/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:vendor/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:vendor/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:vendor/etc/audio_policy_volumes.xml

# Init and recovery general configuration
PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.qca.rc:root/init.bt-wlan.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/nitrogen8m/init.imx8mq.rc:root/init.freescale.imx8mq.rc \
	device/boundary/nitrogen8m/init.usb.rc:root/init.freescale.usb.rc \
	device/boundary/nitrogen8m/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nitrogen8m/fstab.freescale:root/fstab.freescale \
	device/boundary/common/ota.conf:vendor/etc/ota.conf

# Hardware declaration
PRODUCT_COPY_FILES += \
	device/boundary/nitrogen8m/required_hardware.xml:vendor/etc/permissions/required_hardware.xml \
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
	frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
	frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
	frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
	frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
	frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml

# Input configuration
PRODUCT_COPY_FILES += \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/silead_ts.idc

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
	device/boundary/nitrogen8m/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
	device/boundary/nitrogen8m/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

# Audio HAL
PRODUCT_PACKAGES += \
	android.hardware.audio@2.0-impl \
	android.hardware.audio@2.0-service \
	android.hardware.audio.effect@2.0-impl

# Bluetooth HAL
PRODUCT_PACKAGES += \
	android.hardware.bluetooth@1.0-impl \
	android.hardware.bluetooth@1.0-service

# DRM HAL
TARGET_ENABLE_MEDIADRM_64 := true
PRODUCT_PACKAGES += \
	android.hardware.drm@1.0-impl \
	android.hardware.drm@1.0-service

# Gatekeeper HAL
PRODUCT_PACKAGES += \
	android.hardware.gatekeeper@1.0-impl \
	android.hardware.gatekeeper@1.0-service

# Gralloc HAL
PRODUCT_PACKAGES += \
	android.hardware.graphics.mapper@2.0-impl \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.allocator@2.0-service

# HWC2 HAL
PRODUCT_PACKAGES += \
	android.hardware.graphics.composer@2.1-impl \
	android.hardware.graphics.composer@2.1-service

# Keymaster HAL
PRODUCT_PACKAGES += \
	android.hardware.keymaster@3.0-impl \
	android.hardware.keymaster@3.0-service

# Light HAL
PRODUCT_PACKAGES += \
	android.hardware.light@2.0-impl \
	android.hardware.light@2.0-service

# Power HAL
PRODUCT_PACKAGES += \
	android.hardware.power@1.0-impl \
	android.hardware.power@1.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
	android.hardware.renderscript@1.0-impl

# USB HAL
PRODUCT_PACKAGES += \
	android.hardware.usb@1.0-service

# WiFi HAL
PRODUCT_PACKAGES += \
	android.hardware.wifi@1.0-service \
	wifilogd \
	wificond

PRODUCT_PROPERTY_OVERRIDES += \
	ro.backlight.dev=backlight_mipi_dsi \
	ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/nitrogen8m/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
	device/boundary/common/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf     \
	device/boundary/common/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf     \

PRODUCT_PACKAGES += \
	qcacld_wlan.ko \
	bdwlan30.bin \
	otp30.bin \
	qca/tfbtfw11.tlv \
	qca/tfbtnv11.bin \
	qwlan30.bin \
	utf30.bin \
	utfbd30.bin \
	wlan/cfg.dat \
	wlan/qcom_cfg.ini

BOARD_CUSTOM_BT_CONFIG := device/boundary/nitrogen8m/libbt_vnd.conf

# Misc packages
PRODUCT_PACKAGES += \
	su

# GPU packages
PRODUCT_PACKAGES += \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGLESv2_VIVANTE \
	gralloc_viv.imx8 \
	libGAL \
	libGLSLC \
	libVSC \
	libg2d \
	libgpuhelper \
	libSPIRV_viv \
	libvulkan_VIVANTE \
	vulkan.imx8 \
	gatekeeper.imx8

PRODUCT_COPY_FILES += \
	$(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib64/egl/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib64/egl/egl.cfg \
	$(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib/egl/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/egl/egl.cfg

# VPU packages
PRODUCT_PACKAGES += \
	libg1 \
	libhantro \
	libcodec

PRODUCT_PACKAGES += \
	Launcher3

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
PRODUCT_PROPERTY_OVERRIDES += \
	ro.product.first_api_level=26

PRODUCT_PROPERTY_OVERRIDES += \
	ro.frp.pst=/dev/block/bootdevice/by-name/frp
