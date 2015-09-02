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
	device/boundary/common/init.superuser.rc:root/init.superuser.rc \
	device/boundary/nit6xlite/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nit6xlite/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nit6xlite/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/boundary/nit6xlite/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/nit6xlite/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/nit6xlite/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	device/boundary/nit6xlite/bcm4330.hcd:system/etc/firmware/bcm4330.hcd \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \
	device/boundary/brcm/brcmfmac4330-sdio.bin:system/etc/firmware/brcm/brcmfmac4330-sdio.bin \
	device/boundary/brcm/brcmfmac4330-sdio.txt:system/etc/firmware/brcm/brcmfmac4330-sdio.txt

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.config.low_ram=true \
       ro.sf.lcd_density=160

LIBBT_VENDORFILE      := device/boundary/nit6xlite/libbt_vnd_nit6xlite.conf
BOARD_WLAN_DEVICE_REV := bcm4330_b2
WIFI_BAND             := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

DEVICE_PACKAGE_OVERLAYS := device/boundary/nit6xlite/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += uim-sysfs \
		audio.a2dp.default \
		memtool \
		lib_driver_cmd_bcmdhd \
		brcm_patchram_plus

# WiFi Direct requirements
PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf

include device/boundary/openssh.mk

PRODUCT_PACKAGES += ethernet \
        CMFileManager \
        Superuser \
        su
