KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#Enable this to config 1GB DDR
LOW_MEMORY := true

# Enable this to include trusty support
PRODUCT_IMX_TRUSTY := false

#Enable this to disable product partition build.
IMX_NO_PRODUCT_PARTITION := true

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
