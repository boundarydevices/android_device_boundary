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
	device/fsl/imx6/etc/ueventd.freescale.rc:root/ueventd.boundary.rc \
	device/boundary/nit6xlite/vold.fstab:system/etc/vold.fstab \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
        frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/base/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	kernel_imx/drivers/net/wireless/bcmdhd/bcmdhd.ko:boot/lib/modules/bcmdhd.ko \
	device/boundary/bcmdhd/bcmdhd.cal:system/etc/firmware/bcmdhd.cal \
	device/boundary/bcmdhd/fw_bcmdhd.bin:system/etc/firmware/fw_bcmdhd.bin \


PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/nit6xlite/overlay

