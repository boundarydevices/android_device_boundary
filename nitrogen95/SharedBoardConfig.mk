# -------@block_kernel_bootimg-------
KERNEL_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
IMX95_USES_GKI := false
LOADABLE_KERNEL_MODULE ?= true

# -------@block_security-------
# Enable this to include trusty support
PRODUCT_IMX_TRUSTY := false

# Wi-Fi & Bluetooth driver modules
BOARD_VENDOR_KERNEL_MODULES += \
    $(wildcard $(PRODUCT_OUT)/obj/BACKPORTS_OBJ/*.ko)

BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko
