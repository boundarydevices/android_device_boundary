# -------@block_kernel_bootimg-------

KERNEL_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
IMX8MM_USES_GKI := false

# -------@block_memory-------
LOW_MEMORY := false

# -------@block_security-------
# Enable this to include trusty support
PRODUCT_IMX_TRUSTY := false

# -------@block_kernel-------
# Bluetooth driver moduls
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/bluetooth/btbcm.ko \
    $(KERNEL_OUT)/drivers/bluetooth/btqca.ko \
    $(KERNEL_OUT)/drivers/bluetooth/hci_uart.ko

# QCA9377 wifi driver module
BOARD_HAS_QCACLD_MODULE := true
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/QCACLD_OBJ/wlan.ko

# Dummy battery module for CTS
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko
