$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := h4
PRODUCT_DEVICE := h4
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/h4/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/h4/init.rc:root/init.freescale.rc \
	device/boundary/init.superuser.rc:root/init.superuser.rc \
	device/boundary/h4/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/h4/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/Azoteq_IQS5xx_Touchscreen.idc \
	device/boundary/h4/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/h4/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

DEVICE_PACKAGE_OVERLAYS := device/boundary/h4/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

# WiFi requirements
PRODUCT_PACKAGES += \
	dhcpcd.conf \
	hostapd.conf

PRODUCT_COPY_FILES += \
	device/boundary/brcm/brcmfmac43362-sdio.bin:system/etc/firmware/brcm/brcmfmac43362-sdio.bin \
	device/boundary/brcm/brcmfmac43362-sdio.txt:system/etc/firmware/brcm/brcmfmac43362-sdio.txt

include device/boundary/openssh.mk

SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += \
        CMFileManager \
        Superuser \
        su
