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
    device/amlogic/darwin/init.amlogic.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.usb.rc \
    device/amlogic/darwin/init.amlogic.board.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.board.rc

ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/amlogic/common/products/tv/ueventd.amlogic.rc:vendor/ueventd.rc
else
PRODUCT_COPY_FILES += device/amlogic/common/products/tv/ueventd.amlogic.rc:recovery/root/ueventd.amlogic.rc
endif


PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/amlogic/darwin/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    device/amlogic/darwin/files/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/amlogic/darwin/files/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/amlogic/darwin/files/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/amlogic/darwin/files/mesondisplay.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mesondisplay.cfg

ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/amlogic/darwin/files/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
else
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
endif

# remote IME config file
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/remote.conf:$(TARGET_COPY_OUT_VENDOR)/etc/remote.conf \
    device/amlogic/darwin/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    device/amlogic/darwin/files/remote.tab:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab \
    device/amlogic/common/products/tv/Vendor_0001_Product_0001.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/amlogic/common/products/tv/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/Generic.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/Generic.kl:/$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
endif

# recovery
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/recovery/init.recovery.amlogic.rc:root/init.recovery.amlogic.rc \
    device/amlogic/darwin/recovery/recovery.kl:recovery/root/etc/recovery.kl \
    device/amlogic/darwin/files/mesondisplay.cfg:recovery/root/etc/mesondisplay.cfg \
    device/amlogic/darwin/recovery/remotecfg:recovery/root/sbin/remotecfg \
    device/amlogic/darwin/files/remote.cfg:recovery/root/etc/remote.cfg \
    device/amlogic/darwin/files/remote.tab:recovery/root/etc/remote.tab \
    device/amlogic/darwin/recovery/sh:recovery/root/sbin/sh

# darwin config file
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/tv/tvconfig.conf:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/tvconfig.conf \
    device/amlogic/darwin/files/tv/tv_default.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/tv_default.cfg \
    device/amlogic/darwin/files/tv/tv_default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/tv_default.xml \
    device/amlogic/darwin/files/tv/tv_setting_config.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/tv_setting_config.cfg \
    device/amlogic/darwin/files/tv/pq.db:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/pq.db \
    device/amlogic/darwin/files/tv/dec:$(TARGET_COPY_OUT_VENDOR)/bin/dec \
    device/amlogic/darwin/files/tv/port_14.bin:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/hdmi/port_14.bin \
    device/amlogic/darwin/files/tv/port_20.bin:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/hdmi/port_20.bin \
    device/amlogic/darwin/files/tv/tv_rrt_define.xml:$(TARGET_COPY_OUT_VENDOR)/etc/tvconfig/tv_rrt_define.xml
#darwin tuner
PRODUCT_COPY_FILES += \
    device/amlogic/darwin/files/tv/si2151_fe.ko:$(TARGET_COPY_OUT_VENDOR)/lib/si2151_fe.ko

PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# PRODUCT_CHARACTERISTICS := darwin,nosdcard

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
