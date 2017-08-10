$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nit6xlite
PRODUCT_DEVICE := nit6xlite
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.bcm.rc:root/init.bt-wlan.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/nit6xlite/init.i.MX6DL.rc:root/init.freescale.i.MX6DL.rc \
	device/boundary/nit6xlite/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nit6xlite/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nit6xlite/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/silead_ts.idc \
	device/boundary/common/gsl1680.fw:system/etc/firmware/silead/gsl1680.fw \
	device/boundary/common/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/common/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/nit6xlite/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \
	device/boundary/brcm/bcm4330.hcd:system/etc/firmware/bcm4330.hcd \
	device/boundary/brcm/brcmfmac4330-sdio.bin:system/etc/firmware/brcm/brcmfmac4330-sdio.bin \
	device/boundary/brcm/brcmfmac4330-sdio.txt:system/etc/firmware/brcm/brcmfmac4330-sdio.txt

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160

LIBBT_VENDORFILE      := device/boundary/nit6xlite/libbt_vnd_nit6xlite.conf
BOARD_WLAN_DEVICE_REV := bcm4330_b2
WIFI_BAND             := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/nit6xlite/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += \
    audio.a2dp.default

# ExFat support
PRODUCT_PACKAGES += \
    fsck.exfat \
    libfuse \
    mkfs.exfat \
    mount.exfat

# WiFi Direct requirements
PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf

PRODUCT_PACKAGES += \
	ethernet \
	CMFileManager \
	su
