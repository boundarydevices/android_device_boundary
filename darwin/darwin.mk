# Copyright (C) 2011 Amlogic Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Dynamic enable start/stop zygote_secondary in 64bits
# and 32bit system, default closed
#TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE := true

# Inherit from those products. Most specific first.
ifeq ($(ANDROID_BUILD_TYPE), 64)
ifeq ($(TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE), true)
$(call inherit-product, device/amlogic/common/dynamic_zygote_seondary/dynamic_zygote_64_bit.mk)
else
$(call inherit-product, build/target/product/core_64_bit.mk)
endif
endif

$(call inherit-product, device/amlogic/common/products/tv/product_tv.mk)
$(call inherit-product, device/amlogic/darwin/device.mk)
$(call inherit-product, device/amlogic/darwin/vendor_prop.mk)
$(call inherit-product-if-exists, vendor/amlogic/darwin/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

# darwin:


PRODUCT_PROPERTY_OVERRIDES += \
        sys.fb.bits=32 \
        ro.hdmi.device_type=5

PRODUCT_NAME := darwin
PRODUCT_DEVICE := darwin
PRODUCT_BRAND := Amlogic
PRODUCT_MODEL := Darwin
PRODUCT_MANUFACTURER := Amlogic

TARGET_KERNEL_BUILT_FROM_SOURCE := false

PRODUCT_TYPE := tv

WITH_LIBPLAYER_MODULE := false

OTA_UP_PART_NUM_CHANGED := true

BOARD_AML_VENDOR_PATH := vendor/amlogic/common/

BOARD_WIDEVINE_TA_PATH := vendor/amlogic/

#AB_OTA_UPDATER :=true
BUILD_WITH_AVB := true

ifeq ($(BUILD_WITH_AVB),true)
BOARD_AVB_ENABLE := true
#BOARD_BUILD_DISABLED_VBMETAIMAGE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := device/amlogic/common/security/testkey_rsa2048.pem
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifeq ($(AB_OTA_UPDATER),true)
AB_OTA_PARTITIONS := \
    boot \
    system \
    vendor \
    odm

TARGET_BOOTLOADER_CONTROL_BLOCK := true
TARGET_NO_RECOVERY := true
ifneq ($(BUILD_WITH_AVB),true)
TARGET_PARTITION_DTSI := partition_mbox_ab.dtsi
else
TARGET_PARTITION_DTSI := partition_mbox_ab_avb.dtsi
endif
else
TARGET_NO_RECOVERY := false

BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

ifeq ($(ANDROID_BUILD_TYPE), 64)
TARGET_PARTITION_DTSI := partition_mbox_normal_P_64.dtsi
else
TARGET_PARTITION_DTSI := partition_mbox_normal_P_32.dtsi
endif

ifneq ($(BUILD_WITH_AVB),true)
TARGET_FIRMWARE_DTSI := firmware_normal.dtsi
else
ifeq ($(BOARD_BUILD_SYSTEM_ROOT_IMAGE), true)
ifeq ($(BOARD_BUILD_DISABLED_VBMETAIMAGE), true)
TARGET_FIRMWARE_DTSI := firmware_system.dtsi
else
TARGET_FIRMWARE_DTSI := firmware_avb_system.dtsi
endif
else
ifeq ($(BOARD_BUILD_DISABLED_VBMETAIMAGE), true)
TARGET_FIRMWARE_DTSI := firmware_normal.dtsi
else
TARGET_FIRMWARE_DTSI := firmware_avb.dtsi
endif
endif
endif

BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

#########Support compiling out encrypted zip/aml_upgrade_package.img directly
#PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY := true
PRODUCT_AML_SECUREBOOT_USERKEY := ./uboot/board/amlogic/txlx_t962e_r321_v1/aml-user-key.sig
PRODUCT_AML_SECUREBOOT_SIGNTOOL := ./uboot/fip/txlx/aml_encrypt_txlx
PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --bootsig \
						--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY) \
						--aeskey enable
PRODUCT_AML_SECUREBOOT_SIGNIMAGE := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --imgsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)
PRODUCT_AML_SECUREBOOT_SIGBIN	:= $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --binsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)

########################################################################
#
#                           ATV
#
########################################################################
ifneq ($(BOARD_COMPILE_ATV),false)
BOARD_COMPILE_CTS := true
TARGET_BUILD_GOOGLE_ATV:= true
DONT_DEXPREOPT_PREBUILTS:= true
endif
########################################################################

########################################################################
#
#                           Live TV
#
########################################################################
ifneq ($(TARGET_BUILD_GOOGLE_ATV),true)
TARGET_BUILD_LIVETV := true
endif

########################################################################
#
#                           CTS
#
########################################################################
ifeq ($(BOARD_COMPILE_CTS),true)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
BOARD_PLAYREADY_LEVEL := 1
TARGET_BUILD_CTS:= true
TARGET_BUILD_NETFLIX:= true
endif
########################################################################

#########################################################################
#
#                                                Dm-Verity
#
#########################################################################
#BUILD_WITH_DM_VERITY := true
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
BUILD_WITH_DM_VERITY := true
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_PACKAGES += \
	libfs_mgr \
	fs_mgr \
	slideshow
endif

PRODUCT_COPY_FILES += \
    device/amlogic/darwin/fstab.system.amlogic:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.amlogic

#########################################################################
#
#                                                WiFi
#
#########################################################################

WIFI_MODULE := bcm4356
WIFI_BUILD_IN := true
include device/amlogic/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/wifi/config.txt:system/etc/wifi/4354/config.txt

#########################################################################
#
#                                                Bluetooth
#
#########################################################################

BOARD_HAVE_BLUETOOTH := true
BCMBT_SUPPORT := true
#MULTI_BLUETOOTH_SUPPORT := true
BCM_BLUETOOTH_LPM_ENABLE := true
include device/amlogic/common/bluetooth.mk


#########################################################################
#
#                                                ConsumerIr
#
#########################################################################

#PRODUCT_PACKAGES += \
#    consumerir.amlogic \
#    SmartRemote
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml


#PRODUCT_PACKAGES += libbt-vendor

ifeq ($(SUPPORT_HDMIIN),true)
PRODUCT_PACKAGES += \
    libhdmiin \
    HdmiIn
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

# Audio
#
BOARD_ALSA_AUDIO=tiny
include device/amlogic/common/audio.mk

#########################################################################
#
#                                                Camera
#
#########################################################################

ifneq ($(TARGET_BUILD_CTS), true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml
endif



#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP
#########################################################################
#
#                                                Verimatrix DRM
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################


#DRM Widevine
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
TARGET_ENABLE_TA_SIGN := false
TARGET_USE_HW_KEYMASTER := true
endif

$(call inherit-product, device/amlogic/common/media.mk)

#########################################################################
#
#                                                Languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US en_AU en_IN fr_FR it_IT es_ES et_EE de_DE nl_NL cs_CZ pl_PL ja_JP \
  zh_TW zh_CN zh_HK ru_RU ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG \
  ca_ES en_GB fi_FI hi_IN hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA \
  vi_VN tl_PH ar_EG fa_IR th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN en_XA ar_XB fr_CA km_KH \
  lo_LA ne_NP si_LK mn_MN hy_AM az_AZ ka_GE my_MM mr_IN ml_IN is_IS mk_MK ky_KG eu_ES gl_ES \
  bn_BD ta_IN kn_IN te_IN uz_UZ ur_PK kk_KZ

#################################################################################
#
#                                                PPPOE
#
#################################################################################
#ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
#BUILD_WITH_PPPOE := false
#endif

ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.software.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.platform.has.pppoe=true
endif

#################################################################################
#
#                                                DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true


include device/amlogic/common/software.mk
ifeq ($(TARGET_BUILD_GOOGLE_ATV),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240
endif

# hdcp_tx22
PRODUCT_COPY_FILES += \
    device/amlogic/common/hdcp_tx22/hdcp_tx22:vendor/bin/hdcp_tx22

#########################################################################
#
#                                     A/B update
#
#########################################################################
ifeq ($(BUILD_WITH_AVB),true)
PRODUCT_PACKAGES += \
	bootctrl.avb \
	libavb_user
endif

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    bootctrl.amlogic \
    bootctl

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier \
    delta_generator \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service
endif

include device/amlogic/common/gpu/mali450-user-arm64.mk

