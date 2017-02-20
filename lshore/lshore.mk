$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := lshore
PRODUCT_DEVICE := lshore
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/lshore/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/lshore/init.rc:root/init.freescale.rc \
	device/boundary/init.superuser.rc:root/init.superuser.rc \
	device/boundary/lshore/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/lshore/setwlanmac:system/bin/setwlanmac \
	device/boundary/lshore/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ILI210x_Touchscreen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/fusion_F0710A.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/gslx680.idc \
	device/boundary/common/gsl1680.fw:system/etc/firmware/gsl1680.fw \
	device/boundary/lshore/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/wl127x-fw-5-mr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-mr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:system/etc/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:system/etc/firmware/ti-connectivity/TIInit_7.2.31.bts \
	device/boundary/lshore/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/lshore/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	device/boundary/expose-leds:system/bin/expose-leds \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := device/boundary/lshore/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += uim-sysfs \
        bt_sco_app \
        libbt-vendor \
        BluetoothSCOApp \
        memtool \
        TIInit_10.6.15.bts \
        TIInit_7.2.31.bts \
        TIInit_7.6.15.bts

PRODUCT_PACKAGES += \
	wl127x-fw-5-sr.bin \
	wl1271-nvs.bin

# WiFi Direct requirements
PRODUCT_PACKAGES += \
    TQS_D_1.7.ini \
    dhcpcd.conf \
    hostapd.conf

include device/boundary/openssh.mk

SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += ethernet \
        CMFileManager \
        sensors.imx6 \
        Superuser \
        su
