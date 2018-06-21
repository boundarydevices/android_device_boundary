-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := dnx
PRODUCT_DEVICE := dnx
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary
KERNEL_IMX_PATH := vendor/boundary
UBOOT_IMX_PATH := vendor/boundary

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

# DNX-specific packages
PRODUCT_COPY_FILES += \
	device/boundary/dnx/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/boundary/dnx/bootinit.sh:system/bin/bootinit \
	device/boundary/dnx/bootsound.sh:system/bin/bootsound \
	device/boundary/dnx/media/bootanimation.zip:system/media/bootanimation.zip \
	device/boundary/dnx/media/bootup.wav:system/media/bootup.wav

# Init and recovery general configuration
PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/dnx/init.i.MX6Q.rc:root/init.freescale.i.MX6Q.rc \
	device/boundary/dnx/required_hardware.xml:vendor/etc/permissions/required_hardware.xml \
	device/boundary/dnx/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/dnx/fstab.freescale:root/fstab.freescale \
	device/boundary/common/ota.conf:vendor/etc/ota.conf

# VPU firmware
PRODUCT_COPY_FILES += \
	$(LINUX_FIRMWARE_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:vendor/lib/firmware/vpu/vpu_fw_imx6d.bin \
	$(LINUX_FIRMWARE_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:vendor/lib/firmware/vpu/vpu_fw_imx6q.bin

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
	device/boundary/dnx/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
	device/boundary/dnx/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
	device/boundary/dnx/manifest.xml:vendor/manifest.xml

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Audio HAL
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl

# Power HAL
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service

# Light HAL
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wifilogd \
    wificond

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/dnx/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += uim-sysfs \
	bt_sco_app \
	libbt-vendor \
	BluetoothSCOApp \
	TQS_D_1.7.ini

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
	device/boundary/common/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf     \
	device/boundary/common/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf     \

PRODUCT_COPY_FILES += \
	device/boundary/common/init.ti.rc:root/init.bt-wlan.rc \
	device/boundary/wl12xx/wl127x-nvs.bin:vendor/firmware/ti-connectivity/wl127x-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:vendor/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/wl127x-fw-5-mr.bin:vendor/firmware/ti-connectivity/wl127x-fw-5-mr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:vendor/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:vendor/firmware/ti-connectivity/TIInit_7.2.31.bts

# Misc packages
PRODUCT_PACKAGES += \
	su

# GPU packages
PRODUCT_PACKAGES += \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGLESv2_VIVANTE \
	libGAL \
	libGLSLC \
	libVSC \
	libg2d \
	libgpuhelper

PRODUCT_PROPERTY_OVERRIDES += \
	ro.frp.pst=/dev/block/bootdevice/by-name/frp
