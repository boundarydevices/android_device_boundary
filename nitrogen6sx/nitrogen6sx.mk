$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nitrogen6sx
PRODUCT_DEVICE := nitrogen6sx
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/nitrogen6sx/init.i.MX6SX.rc:root/init.freescale.i.MX6SX.rc \
	device/boundary/nitrogen6sx/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nitrogen6sx/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nitrogen6sx/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ILI210x_Touchscreen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/fusion_F0710A.idc \
	device/boundary/common/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/common/audio_effects.conf:vendor/etc/audio_effects.conf \
	device/boundary/common/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/nitrogen6sx/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += \
	audio.a2dp.default

PRODUCT_COPY_FILES += \
	device/boundary/common/init.bcm.rc:root/init.bt-wlan.rc \
	device/boundary/nitrogen6sx/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	device/boundary/brcm/bcm43340.hcd:system/etc/firmware/bcm43340.hcd \
	device/boundary/brcm/brcmfmac43340-sdio.bin:system/etc/firmware/brcm/brcmfmac43340-sdio.bin \
	device/boundary/brcm/brcmfmac43340-sdio.txt:system/etc/firmware/brcm/brcmfmac43340-sdio.txt

BOARD_CUSTOM_BT_CONFIG := device/boundary/nitrogen6sx/libbt_vnd_nitrogen6sx.conf
BOARD_WLAN_DEVICE_REV  := bcm4330_b2
WIFI_BAND              := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

# ExFat support
PRODUCT_PACKAGES += \
    fsck.exfat \
    libfuse \
    mkfs.exfat \
    mount.exfat

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf

PRODUCT_PACKAGES += \
	ethernet \
	CMFileManager \
	su

PRODUCT_COPY_FILES += \
    device/fsl-proprietary/gpu-viv/lib/egl/egl.cfg:system/lib/egl/egl.cfg

PRODUCT_PACKAGES += \
    libEGL_VIVANTE \
    libGLESv1_CM_VIVANTE \
    libGLESv2_VIVANTE \
    gralloc_viv.imx6 \
    hwcomposer_viv.imx6 \
    hwcomposer_fsl.imx6 \
    libGAL \
    libGLSLC \
    libVSC \
    libg2d \
    libgpuhelper
