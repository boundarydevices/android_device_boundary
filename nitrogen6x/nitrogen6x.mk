-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)
include device/boundary/nitrogen6x/wifi_config.mk

# Overrides
PRODUCT_NAME := nitrogen6x
PRODUCT_DEVICE := nitrogen6x
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
	device/boundary/nitrogen6x/init.i.MX6DL.rc:root/init.freescale.i.MX6DL.rc \
	device/boundary/nitrogen6x/init.i.MX6Q.rc:root/init.freescale.i.MX6Q.rc \
	device/boundary/nitrogen6x/init.i.MX6QP.rc:root/init.freescale.i.MX6QP.rc \
	device/boundary/nitrogen6x/required_hardware.xml:vendor/etc/permissions/required_hardware.xml \
	device/boundary/nitrogen6x/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nitrogen6x/fstab.freescale:root/fstab.freescale \
	device/boundary/common/ota.conf:vendor/etc/ota.conf

# Input configuration
PRODUCT_COPY_FILES += \
	device/fsl/common/input/eGalax_Touch_Screen.idc:vendor/usr/idc/eGalax_Touch_Screen.idc \
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

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
	device/boundary/nitrogen6x/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
	device/boundary/nitrogen6x/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
	device/boundary/nitrogen6x/manifest.xml:vendor/manifest.xml

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

# Bluetooth HAL (TI chip requires a custom service)
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl

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
	device/boundary/nitrogen6x/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
	device/boundary/common/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf     \
	device/boundary/common/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf     \

ifeq ($(BOARD_WLAN_VENDOR),TI)
PRODUCT_PACKAGES += uim-sysfs \
	android.hardware.bluetooth@1.0-service.ti \
	bt_sco_app \
	BluetoothSCOApp \
	TQS_D_1.7.ini

PRODUCT_COPY_FILES += \
	device/boundary/common/init.ti.rc:root/init.bt-wlan.rc \
	device/boundary/wl12xx/wl127x-nvs.bin:vendor/firmware/ti-connectivity/wl127x-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:vendor/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/wl127x-fw-5-mr.bin:vendor/firmware/ti-connectivity/wl127x-fw-5-mr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:vendor/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:vendor/firmware/ti-connectivity/TIInit_7.2.31.bts
endif

ifeq ($(BOARD_WLAN_VENDOR),BCM)
PRODUCT_PACKAGES += \
	android.hardware.bluetooth@1.0-service \
	audio.a2dp.default

PRODUCT_COPY_FILES += \
	device/boundary/common/init.bcm.rc:root/init.bt-wlan.rc \
	device/boundary/nitrogen6x/bt_vendor.conf:vendor/bluetooth/bt_vendor.conf \
	device/boundary/brcm/bcm43340.hcd:vendor/firmware/bcm43340.hcd \
	device/boundary/brcm/brcmfmac43340-sdio.bin:vendor/firmware/brcm/brcmfmac43340-sdio.bin \
	device/boundary/brcm/brcmfmac43340-sdio.txt:vendor/firmware/brcm/brcmfmac43340-sdio.txt

BOARD_CUSTOM_BT_CONFIG := device/boundary/nitrogen6x/libbt_vnd.conf
BOARD_WLAN_DEVICE_REV  := bcm4330_b2
WIFI_BAND              := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)
endif

ifeq ($(BOARD_WLAN_VENDOR),QCA)
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

BOARD_CUSTOM_BT_CONFIG := device/boundary/nitrogen6x/libbt_vnd.conf
endif

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
