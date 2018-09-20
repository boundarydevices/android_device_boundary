#
# Copyright (C) 2013 The Android Open-Source Project
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

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

PRODUCT_COPY_FILES += \
    device/amlogic/braun/init.amlogic.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.usb.rc \
    device/amlogic/braun/init.amlogic.board.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.board.rc

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/ueventd.amlogic.rc:vendor/ueventd.rc

PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/amlogic/braun/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    device/amlogic/braun/files/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/amlogic/braun/files/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/amlogic/braun/files/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/amlogic/braun/files/mesondisplay.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mesondisplay.cfg \
    device/amlogic/braun/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    device/amlogic/braun/files/remote.tab1:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab1 \
    device/amlogic/braun/files/remote.tab2:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab2 \
    device/amlogic/braun/files/remote.tab3:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab3 \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml

ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/amlogic/braun/files/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
else
PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
endif

ifeq ($(TARGET_WITH_MEDIA_EXT), true)
PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/media_codecs_ext.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_ext.xml
endif

PRODUCT_COPY_FILES += \
    device/amlogic/braun/recovery/init.recovery.amlogic.rc:root/init.recovery.amlogic.rc \
    device/amlogic/braun/recovery/recovery.kl:recovery/root/etc/recovery.kl \
    device/amlogic/braun/files/mesondisplay.cfg:recovery/root/etc/mesondisplay.cfg \
    device/amlogic/braun/recovery/remotecfg:recovery/root/sbin/remotecfg \
    device/amlogic/braun/files/remote.cfg:recovery/root/etc/remote.cfg \
    device/amlogic/braun/files/remote.tab1:recovery/root/etc/remote.tab1 \
    device/amlogic/braun/files/remote.tab2:recovery/root/etc/remote.tab2 \
    device/amlogic/braun/files/remote.tab3:recovery/root/etc/remote.tab3 \
    device/amlogic/braun/recovery/sh:recovery/root/sbin/sh

# remote IME config file
PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/Vendor_0001_Product_0001.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/amlogic/common/products/mbox/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/amlogic/braun/files/Generic.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/Generic.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
endif
PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := mbx,nosdcard

PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

#To remove healthd from the build
PRODUCT_PACKAGES += android.hardware.health@2.0-service.override
DEVICE_FRAMEWORK_MANIFEST_FILE += \
	system/libhidl/vintfdata/manifest_healthd_exclude.xml

#To keep healthd in the build
PRODUCT_PACKAGES += android.hardware.health@2.0-service
