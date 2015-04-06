$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := ls
PRODUCT_DEVICE := ls
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/ls/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/ls/init.rc:root/init.freescale.rc \
	device/boundary/ls/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/ls/setwlanmac:system/bin/setwlanmac \
	device/boundary/ls/fstab.freescale:root/fstab.freescale \
	device/boundary/ls/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:system/etc/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:system/etc/firmware/ti-connectivity/TIInit_7.2.31.bts \
	device/boundary/ls/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/ls/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/ls/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += uim-sysfs \
        bt_sco_app \
        BluetoothSCOApp \
        memtool \
        TIInit_10.6.15.bts \
        TIInit_7.2.31.bts \
        TIInit_7.6.15.bts

PRODUCT_PACKAGES += \
	wl127x-fw-5-sr.bin \
	wl1271-nvs.bin

include device/boundary/openssh.mk

SUPERUSER_PACKAGE := com.boundary.superuser

SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += \
        Superuser
