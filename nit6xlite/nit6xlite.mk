$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nit6xlite
PRODUCT_DEVICE := nit6xlite
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/nit6xlite/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nit6xlite/init.rc:root/init.freescale.rc \
	device/boundary/nit6xlite/init.rc:root/init.boundary.rc \
	device/boundary/nit6xlite/ueventd.boundary.rc:root/ueventd.freescale.rc \
	device/boundary/nit6xlite/vold.fstab:system/etc/vold.fstab \
	device/boundary/nit6xlite/fstab.boundary:root/fstab.boundary \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
	bootable/bootloader/uboot-imx/u-boot.imx:boot/u-boot.imx \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	device/boundary/bcmdhd/bcmdhd.cal:system/etc/firmware/bcmdhd.cal \
	device/boundary/bcmdhd/fw_bcmdhd.bin:system/etc/firmware/fw_bcmdhd.bin \
	device/boundary/nit6xlite/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/nit6xlite/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/nit6xlite/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	device/boundary/nit6xlite/bcm4330.hcd:system/etc/firmware/bcm4330.hcd \


PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

BOARD_WLAN_DEVICE_REV := bcm4330_b2
WIFI_BAND             := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

DEVICE_PACKAGE_OVERLAYS := device/boundary/nit6xlite/overlay

PRODUCT_PACKAGES += uim-sysfs \
		audio.a2dp.default \
		lib_driver_cmd_bcmdhd \
		brcm_patchram_plus

include device/boundary/openssh.mk

PRODUCT_PACKAGES += ethernet
