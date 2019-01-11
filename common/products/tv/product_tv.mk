$(call inherit-product, device/amlogic/common/core_amlogic.mk)


#TV input HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.input@1.0-impl \
    android.hardware.tv.input@1.0-service \
    vendor.amlogic.hardware.tvserver@1.0_vendor \
    tv_input.amlogic

# TV
PRODUCT_PACKAGES += \
    libtv \
    libtv_linker \
    libtvbinder \
    libtv_jni \
    tvserver \
    libtvplay \
    libvendorfont \
    libTVaudio \
    libntsc_decode \
    libtinyxml \
    libzvbi \
    droidlogic-tv \
    droidlogic.tv.software.core.xml \
    TvProvider \
    DroidLogicTvInput \
    DroidLogicFactoryMenu \
    libjnidtvsubtitle

# DTV
PRODUCT_PACKAGES += \
    libam_adp \
    libam_mw \
    libam_ver \
    libam_sysfs

PRODUCT_PACKAGES += \
    busybox \
    utility_busybox

# LiveTv
PRODUCT_PACKAGES += \
    DroidLiveTv

# DLNA
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
    imageserver \
    DLNA
endif

PRODUCT_PACKAGES += \
    remotecfg

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
# NativeImagePlayer
PRODUCT_PACKAGES += \
    NativeImagePlayer

#MboxLauncher
PRODUCT_PACKAGES += \
    MboxLauncher
endif

#droid vold
PRODUCT_PACKAGES += \
    droidvold

# Camera Hal
PRODUCT_PACKAGES += \
    camera.amlogic

#PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=0

PRODUCT_PACKAGES += \
    OTAUpgrade

PRODUCT_PACKAGES += \
    miracastserver \
    Miracast

#Tvsettings
PRODUCT_PACKAGES += \
    TvSettings \
    DroidTvSettings \
    DroidSoundEffectSettings

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.live_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_tv.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    device/amlogic/common/android.software.leanback.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.leanback.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/amlogic/common/config/lowmemorykiller_2G.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_2G.txt \
	device/amlogic/common/config/lowmemorykiller.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller.txt \
	device/amlogic/common/config/lowmemorykiller_512M.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_512M.txt
endif

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

#usb accessory donnot need in atv
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml
endif

custom_keylayouts := $(wildcard device/amlogic/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(notdir $(file)))

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

#bootvideo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootvideo.zip:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo.zip

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/tv.mp4:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
# default wallpaper for mbox to fix bug 106225
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:$(TARGET_COPY_OUT_VENDOR)/etc/default_wallpaper.png

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.wallpaper=vendor/etc/default_wallpaper.png
endif

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
ifeq ($(VERSION_ID),)
export BUILD_NUMBER := $(shell date +%Y%m%d)
else
$(call inherit-product, $(VERSION_ID))
endif

DISPLAY_BUILD_NUMBER := true

#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
        media.omx.display_mode=1

#TV project, need use 8 ch 32 bit output.
TARGET_WITH_TV_AUDIO_MODE := true

