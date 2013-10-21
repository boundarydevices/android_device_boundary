#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=4.3_1.0.0-beta
TARGET_KERNEL_DEFCONF := oc_defconfig

#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := oc
PRODUCT_MODEL := OC
BOARD_HAS_SGTL5000 := true

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BOARD_KERNEL_CMDLINE := console=ttymxc1,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc1

TARGET_BOOTLOADER_CONFIG := 6q:ocquad_config 6s:ocsolo_config

TARGET_TS_CALIBRATION := true

BOARD_WPA_SUPPLICANT_DRIVER		:= NL80211
WPA_SUPPLICANT_VERSION			:= VER_0_8_X
WIFI_DRIVER_MODULE_NAME			:= "bcmdhd"
BOARD_WPA_SUPPLICANT_PRIVATE_LIB	:= lib_driver_cmd_bcmdhd
SKIP_WPA_SUPPLICAN_CONF                 := y
SKIP_WPA_SUPPLICANT_RTL                 := y
BOARD_WLAN_DEVICE			:= bcmdhd
WIFI_DRIVER_FW_PATH_PARAM		:= "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_MODULE_PATH			:= "/boot/lib/modules/bcmdhd.ko"
WIFI_DRIVER_FW_PATH_STA			:= "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P			:= "/vendor/firmware/fw_bcmdhd_p2p.bin"
WIFI_DRIVER_FW_PATH_AP			:= "/vendor/firmware/fw_bcmdhd_apsta.bin"
BOARD_HAVE_BLUETOOTH 			:= true
BOARD_HAVE_BLUETOOTH_BCM 		:= true
BOARD_USE_AR3K_BLUETOOTH		:= 
