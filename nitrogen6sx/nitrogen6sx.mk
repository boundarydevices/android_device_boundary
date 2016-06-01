$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nitrogen6sx
PRODUCT_DEVICE := nitrogen6sx
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

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
	device/boundary/common/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \

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

LIBBT_VENDORFILE      := device/boundary/nitrogen6sx/libbt_vnd_nitrogen6sx.conf
BOARD_WLAN_DEVICE_REV := bcm4330_b2
WIFI_BAND             := 802_11_ABG
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

PRODUCT_PACKAGES += ethernet \
        CMFileManager \
        Superuser \
        su
