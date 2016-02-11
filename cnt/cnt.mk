$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := cnt
PRODUCT_DEVICE := cnt
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/cnt/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/cnt/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/init.superuser.rc:root/init.superuser.rc \
	device/boundary/cnt/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/cnt/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/Atmel_maXTouch_Touchscreen.idc \
	device/boundary/cnt/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/cnt/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/cnt/ISDTSV10.xcfg:system/etc/firmware/ISDTSV10.xcfg \
	device/boundary/cnt/touchscreen.sh:system/bin/touchscreen \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

PRODUCT_PROPERTY_OVERRIDES += \
       ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := device/boundary/cnt/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_COPY_FILES += \
	device/boundary/cnt/init.rc:root/init.freescale.rc

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf

include device/boundary/openssh.mk

SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += ethernet \
        CMFileManager \
        mxt-app \
        sensors.CNT \
        Superuser \
        su

# NFC configurations and features
PRODUCT_COPY_FILES += \
    device/boundary/cnt/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
    device/boundary/cnt/libnfc-nxp.conf:system/etc/libnfc-nxp.conf \
    frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml

# NFC packages
PRODUCT_PACKAGES += \
    NfcNci \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.pn54x.default \
    Tag
