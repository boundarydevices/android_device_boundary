#
# Copyright (C) 2012 The Android Open Source Project
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

#Support modules:
#   bcm40183, AP6210, AP6476, AP6330, AP62x2,AP6335,mt5931 & mt6622

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
    PRODUCT_PROPERTY_OVERRIDES += config.disable_bluetooth=false \
    ro.autoconnectbt.isneed=false \
    ro.autoconnectbt.macprefix=00:CD:FF \
    ro.autoconnectbt.btclass=50c \
    ro.autoconnectbt.nameprefix=Amlogic_RC

else
    PRODUCT_PROPERTY_OVERRIDES += config.disable_bluetooth=true

endif

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
PRODUCT_PACKAGES += Bluetooth \
    bt_vendor.conf \
    bt_stack.conf \
    bt_did.conf \
    auto_pair_devlist.conf \
    libbt-hci \
    bluetooth.default \
    audio.a2dp.default \
    libbt-client-api \
    com.broadcom.bt \
    com.broadcom.bt.xml \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

PRODUCT_COPY_FILES += \
    hardware/amlogic/bluetooth/broadcom/vendor/data/auto_pairing.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/auto_pairing.conf \
    hardware/amlogic/bluetooth/broadcom/vendor/data/blacklist.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/blacklist.conf


endif

################################################################################## rtl8723bs,rtl8761
#ifeq ($(BLUETOOTH_MODULE),rtl8723bs)
ifneq ($(filter rtl8761 rtl8723bs rtl8723bu rtl8821 rtl8822bu rtl8822bs, $(BLUETOOTH_MODULE)),)

BLUETOOTH_USR_RTK_BLUEDROID := true
#Realtek add start
$(call inherit-product, hardware/amlogic/bluetooth/realtek/rtkbt/rtkbt.mk )
#realtek add end
PRODUCT_PACKAGES += libbt-vendor

#Realtek add start
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml
#realtek add end
endif

################################################################################## qca9377
ifeq ($(BLUETOOTH_MODULE),qca9377)
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := false


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    hardware/amlogic/wifi/qcom/config/qca9377/bt/nvm_tlv_tf_1.1.bin:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/qca9377/ar3k/nvm_tlv_tf_1.1.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/bt/rampatch_tlv_tf_1.1.tlv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/qca9377/ar3k/rampatch_tlv_tf_1.1.tlv

PRODUCT_PROPERTY_OVERRIDES += poweroff.doubleclick=1
PRODUCT_PROPERTY_OVERRIDES += qcom.bluetooth.soc=rome_uart
#PRODUCT_PROPERTY_OVERRIDES += bt.qcom9377.power=off

endif

################################################################################## qca6174
ifeq ($(BLUETOOTH_MODULE),qca6174)
BOARD_HAVE_BLUETOOTH_QCOM := true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    hardware/amlogic/wifi/qcom/config/qca6174/bt/nvm_tlv_3.2.bin:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/qca6174/ar3k/nvm_tlv_3.2.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/bt/rampatch_tlv_3.2.tlv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/qca6174/ar3k/rampatch_tlv_3.2.tlv

PRODUCT_PROPERTY_OVERRIDES += wc_transport.soc_initialized=0

PRODUCT_PACKAGES += libbt-vendor
endif

##################################################################################bcmbt
ifeq ($(BCMBT_SUPPORT), true)

#load bcm mk
$(call inherit-product, hardware/amlogic/bluetooth/broadcom/bcmbt.mk )
#load bcm mk end

BOARD_HAVE_BLUETOOTH_BROADCOM := true

PRODUCT_PACKAGES += libbt-vendor

endif

