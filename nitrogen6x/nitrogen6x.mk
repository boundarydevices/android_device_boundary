$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := nitrogen6x
PRODUCT_DEVICE := nitrogen6x
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/nitrogen6x/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nitrogen6x/init.rc:root/init.freescale.rc \
	device/boundary/nitrogen6x/vold.fstab:system/etc/vold.fstab \

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/nitrogen6x/overlay

