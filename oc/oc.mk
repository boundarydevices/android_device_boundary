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
	device/boundary/oc/ueventd.boundary.rc:root/ueventd.freescale.rc \
	device/boundary/oc/vold.fstab:system/etc/vold.fstab \
	device/boundary/oc/fstab.boundary:root/fstab.boundary \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	device/boundary/bcmdhd/bcmdhd.cal:system/etc/firmware/bcmdhd.cal \
	device/boundary/bcmdhd/fw_bcmdhd.bin:system/etc/firmware/fw_bcmdhd.bin \
	device/boundary/oc/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/oc/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/nit6xlite/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	device/boundary/nit6xlite/bcm4330.hcd:system/etc/firmware/bcm4330.hcd \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \
        frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/oc/overlay

PRODUCT_PACKAGES += lib_driver_cmd_bcmdhd \
		brcm_patchram_plus
