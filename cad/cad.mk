$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := cad
PRODUCT_DEVICE := cad
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/cad/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/cad/init.rc:root/init.freescale.rc \
	device/boundary/cad/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/cad/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/boundary/cad/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/cad/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	device/boundary/expose-leds:system/bin/expose-leds \

PRODUCT_PROPERTY_OVERRIDES += \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/cad/overlay

include device/boundary/openssh.mk

PRODUCT_PACKAGES += ethernet
