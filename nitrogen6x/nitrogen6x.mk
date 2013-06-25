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
	device/boundary/nitrogen6x/init.rc:root/init.boundary.rc \
	device/fsl/imx6/etc/ueventd.freescale.rc:root/ueventd.boundary.rc \
	device/boundary/nitrogen6x/setwlanmac:system/bin/setwlanmac \
	device/boundary/nitrogen6x/vold.fstab:system/etc/vold.fstab \
	device/boundary/nitrogen6x/fstab.boundary:root/fstab.boundary \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/ft5x06.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/tsc2004.idc \
	kernel_imx/arch/arm/boot/uImage:boot/uImage \
	bootable/bootloader/uboot-imx/u-boot.imx:boot/u-boot.imx \
	device/boundary/nitrogen6x/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin \
	device/ti/panda/wl12xx/wl1271-fw-2.bin:system/etc/firmware/ti-connectivity/wl1271-fw-2.bin

PRODUCT_PROPERTY_OVERRIDES += \
       wifi.interface=wlan0 \
       ro.sf.lcd_density=120

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/boundary/nitrogen6x/overlay


PRODUCT_PACKAGES += uim-sysfs \
        bt_sco_app \
        BluetoothSCOApp \
        TIInit_10.6.15.bts \
        TIInit_7.2.31.bts \
        TIInit_7.6.15.bts

PRODUCT_PACKAGES += \
	wl1271-fw-2.bin \
	wl1271-nvs.bin
