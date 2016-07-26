$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := dnx
PRODUCT_DEVICE := dnx
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/common/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/common/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/dnx/bootsound.sh:system/bin/bootsound \
	device/boundary/dnx/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/boundary/dnx/fstab.freescale:root/fstab.freescale \
	device/boundary/dnx/init.i.MX6Q.rc:root/init.freescale.i.MX6Q.rc \
	device/boundary/dnx/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/dnx/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/dnx/media/bootup.wav:system/media/bootup.wav \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/dnx/overlay \
	device/boundary/common/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += uim-sysfs \
	bt_sco_app \
	libbt-vendor \
	BluetoothSCOApp \
	TIInit_10.6.15.bts \
	TIInit_7.2.31.bts \
	TIInit_7.6.15.bts \
	TQS_D_1.7.ini \
	wl127x-fw-5-sr.bin \
	wl1271-nvs.bin

PRODUCT_COPY_FILES += \
	device/boundary/common/init.ti.rc:root/init.bt-wlan.rc \
	device/boundary/dnx/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/wl127x-fw-5-mr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-mr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:system/etc/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:system/etc/firmware/ti-connectivity/TIInit_7.2.31.bts

# ExFat support
PRODUCT_PACKAGES += \
	fsck.exfat \
	libfuse \
	mkfs.exfat \
	mount.exfat

PRODUCT_PACKAGES += \
	dhcpcd.conf \
	hostapd.conf

PRODUCT_PACKAGES += \
	ethernet \
	CMFileManager \
	powerfail
