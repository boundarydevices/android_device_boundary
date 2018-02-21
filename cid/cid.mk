$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,hardware/sierra/user_tags.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides
PRODUCT_NAME := cid
PRODUCT_DEVICE := cid
PRODUCT_BRAND := boundary
PRODUCT_MANUFACTURER := boundary

USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	device/boundary/common/init.rc:root/init.freescale.rc \
	device/boundary/common/init.recovery.rc:root/init.recovery.freescale.rc \
	device/boundary/cid/init.i.MX6Q.rc:root/init.freescale.i.MX6Q.rc \
	device/boundary/cid/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/boundary/cid/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/boundary/cid/fstab.freescale:root/fstab.freescale \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/Atmel_maXTouch_Touchscreen.idc \
	device/boundary/common/apns-full-conf.xml:system/etc/apns-conf.xml \
	device/boundary/common/audio_policy.conf:system/etc/audio_policy.conf \
	device/boundary/common/audio_effects.conf:vendor/etc/audio_effects.conf \
	device/boundary/common/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
	device/boundary/cid/ota.conf:system/etc/ota.conf \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml \
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=240

DEVICE_PACKAGE_OVERLAYS := \
	device/boundary/cid/overlay \
	device/boundary/common/overlay

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi

PRODUCT_PACKAGES += \
	qcacld_wlan.ko \
	bdwlan30.bin \
	otp30.bin \
	qca/tfbtfw11.tlv \
	qca/tfbtnv11.bin \
	qwlan30.bin \
	utf30.bin \
	utfbd30.bin \
	wlan/cfg.dat \
	wlan/qcom_cfg.ini

PRODUCT_COPY_FILES += \
	device/boundary/common/init.qca.rc:root/init.bt-wlan.rc

BOARD_CUSTOM_BT_CONFIG := device/boundary/cid/libbt_vnd_cid.conf

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
	CMFileManager \
	su

PRODUCT_PACKAGES += \
	sensors.cid

PRODUCT_PACKAGES += \
	gps.conf \
	gps.default \
	u-blox.conf

PRODUCT_COPY_FILES += \
	device/fsl-proprietary/gpu-viv/lib/egl/egl.cfg:system/lib/egl/egl.cfg

PRODUCT_PACKAGES += \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGLESv2_VIVANTE \
	gralloc_viv.imx6 \
	hwcomposer_viv.imx6 \
	hwcomposer_fsl.imx6 \
	libGAL \
	libGLSLC \
	libVSC \
	libg2d \
	libgpuhelper
