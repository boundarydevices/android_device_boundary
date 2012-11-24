$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nitrogen6x
PRODUCT_DEVICE := nitrogen6x

PRODUCT_COPY_FILES += \
	device/fsl/imx6/sabresd/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/imx6/sabresd/init.rc:root/init.freescale.rc \
    	device/fsl/imx6/sabresd/vold.fstab:system/etc/vold.fstab \
	device/fsl/imx6/sabresd/gpsreset.sh:system/etc/gpsreset.sh

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/fsl/imx6/sabresd/overlay

