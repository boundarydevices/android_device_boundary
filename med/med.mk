$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := med
PRODUCT_DEVICE := med
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/med/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/med/init.rc:root/init.freescale.rc \
	device/boundary/med/init.rc:root/init.boundary.rc \
	device/boundary/med/ueventd.boundary.rc:root/ueventd.freescale.rc \
	device/boundary/med/fstab.boundary:root/fstab.boundary \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
	device/boundary/med/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/med/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	device/boundary/expose-leds:system/bin/expose-leds \

PRODUCT_PROPERTY_OVERRIDES += \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/med/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

include device/boundary/openssh.mk

SUPERUSER_PACKAGE := com.boundary.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += ethernet \
	memtool
