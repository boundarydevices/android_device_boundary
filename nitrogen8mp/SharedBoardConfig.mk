# -------@block_kernel_bootimg-------
KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64
IMX8MP_USES_GKI := false

# -------@block_memory-------
LOW_MEMORY := false

# -------@block_security-------
# Enable this to include trusty support
PRODUCT_IMX_TRUSTY := false

# QCA9377 wifi driver module
BOARD_HAS_QCACLD_MODULE := true
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/QCACLD_OBJ/wlan.ko

# isp vvcam driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/VVCAM_OBJ/vvcam-video.ko \
    $(TARGET_OUT_INTERMEDIATES)/VVCAM_OBJ/vvcam-isp.ko \
    $(TARGET_OUT_INTERMEDIATES)/VVCAM_OBJ/vvcam-dwe.ko \
    $(TARGET_OUT_INTERMEDIATES)/VVCAM_OBJ/basler-camera-driver-vvcam.ko

# Dummy battery module for CTS
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko

# GPU Vivante driver
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mxc/gpu-viv/galcore.ko
