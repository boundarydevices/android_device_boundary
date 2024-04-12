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
# Wi-Fi & Bluetooth driver modules
BOARD_VENDOR_KERNEL_MODULES += \
    $(wildcard $(PRODUCT_OUT)/obj/BACKPORTS_OBJ/*.ko)

# Dummy battery module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko
