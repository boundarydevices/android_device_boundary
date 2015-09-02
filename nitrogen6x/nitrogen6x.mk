$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)
include device/boundary/nitrogen6x/wifi_config.mk

# Overrides
PRODUCT_NAME := nitrogen6x
PRODUCT_DEVICE := nitrogen6x
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/common/init.superuser.rc:root/init.superuser.rc \
	device/boundary/nitrogen6x/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/nitrogen6x/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/nitrogen6x/setwlanmac:system/bin/setwlanmac \
	device/boundary/nitrogen6x/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ILI210x_Touchscreen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/fusion_F0710A.idc \
	device/boundary/common/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/common/audio_effects.conf:system/vendor/etc/audio_effects.conf \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin      \

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=160

DEVICE_PACKAGE_OVERLAYS := device/boundary/nitrogen6x/overlay

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

ifeq ($(BOARD_WLAN_VENDOR),TI)
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
	device/boundary/nitrogen6x/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin \
	device/boundary/wl12xx/wl127x-fw-5-sr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-sr.bin \
	device/boundary/wl12xx/wl127x-fw-5-mr.bin:system/etc/firmware/ti-connectivity/wl127x-fw-5-mr.bin \
	device/boundary/wl12xx/TIInit_7.6.15.bts:system/etc/firmware/ti-connectivity/TIInit_7.6.15.bts \
	device/boundary/wl12xx/TIInit_7.2.31.bts:system/etc/firmware/ti-connectivity/TIInit_7.2.31.bts
endif

ifeq ($(BOARD_WLAN_VENDOR),BCM)
PRODUCT_PACKAGES += \
	audio.a2dp.default

PRODUCT_COPY_FILES += \
	device/boundary/common/init.bcm.rc:root/init.bt-wlan.rc \
	device/boundary/nitrogen6x/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
	device/boundary/brcm/bcm43340.hcd:system/etc/firmware/bcm43340.hcd \
	device/boundary/brcm/brcmfmac43340-sdio.bin:system/etc/firmware/brcm/brcmfmac43340-sdio.bin \
	device/boundary/brcm/brcmfmac43340-sdio.txt:system/etc/firmware/brcm/brcmfmac43340-sdio.txt

LIBBT_VENDORFILE      := device/boundary/nitrogen6x/libbt_vnd_nitrogen6x.conf
BOARD_WLAN_DEVICE_REV := bcm4330_b2
WIFI_BAND             := 802_11_ABG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)
endif

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf

include device/boundary/openssh.mk

SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += ethernet \
        CMFileManager \
        Superuser \
        su
