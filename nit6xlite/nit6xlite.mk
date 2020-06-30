REMOVE_CAMERA_PACKAGES := true
-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)
include device/boundary/nitrogen6x/wifi_config.mk

# Overrides
PRODUCT_NAME := nit6xlite
PRODUCT_DEVICE := nit6xlite
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

# Init and recovery general configuration
PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/nit6xlite/init.i.MX6DL.rc:root/init.freescale.i.MX6DL.rc \
	device/boundary/nit6xlite/required_hardware.xml:vendor/etc/permissions/required_hardware.xml \
	device/boundary/nit6xlite/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nit6xlite/fstab.freescale:root/fstab.freescale \
	device/boundary/common/ota.conf:vendor/etc/ota.conf

# Input configuration
PRODUCT_COPY_FILES += \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/EETI_eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/ILI210x_Touchscreen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/tsc2004.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/fusion_F0710A.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/silead_ts.idc \
	device/boundary/common/gsl1680.fw:vendor/firmware/silead/gsl1680.fw

# VPU firmware
PRODUCT_COPY_FILES += \
	$(LINUX_FIRMWARE_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:vendor/lib/firmware/vpu/vpu_fw_imx6d.bin \
	$(LINUX_FIRMWARE_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:vendor/lib/firmware/vpu/vpu_fw_imx6q.bin

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
	device/boundary/common/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf     \
	device/boundary/common/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf     \

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
	device/boundary/nit6xlite/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
	device/boundary/nit6xlite/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
	device/boundary/nit6xlite/manifest.xml:vendor/manifest.xml

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

# SDCardFS
PRODUCT_PROPERTY_OVERRIDES += \
	ro.sys.sdcardfs=0

PRODUCT_PACKAGES += \
    start-ssh \
    sshd_config \
    ssh-keygen \
    sshd \
    scp \
    sftp \
    ssh \
    libssh

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/nit6xlite/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += \
	audio.a2dp.default

# WLAN driver configuration files
PRODUCT_PACKAGES += \
	android.hardware.bluetooth@1.0-service \
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

PRODUCT_COPY_FILES += \
	device/boundary/common/init.qca.rc:root/init.bt-wlan.rc

# Specify which rfkill node to use since the first available (rfkill0) is the
# one from the HCI driver in the kernel (net/bluetooth/hci_core.c).
PRODUCT_PROPERTY_OVERRIDES += \
	ro.bt.rfkill.state=/sys/class/rfkill/rfkill1/state

BOARD_CUSTOM_BT_CONFIG := device/boundary/nit6xlite/libbt_vnd_nit6xlite.conf

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
