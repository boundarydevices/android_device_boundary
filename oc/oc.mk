$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := oc
PRODUCT_DEVICE := oc
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/oc/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/oc/init.rc:root/init.freescale.rc \
	device/boundary/oc/init.rc:root/init.boundary.rc \
	device/boundary/oc/vold.fstab:system/etc/vold.fstab \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
	bootable/bootloader/uboot-imx/u-boot.imx:boot/u-boot.imx \
        frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/base/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	kernel_imx/drivers/net/wireless/bcmdhd/bcmdhd.ko:boot/lib/modules/bcmdhd.ko \
	external/imx-utils/devregs_imx6x.dat:system/etc/devregs_imx6x.dat

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/oc/overlay

