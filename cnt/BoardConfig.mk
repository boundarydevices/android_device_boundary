#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=5.0.0_1.0.0-ga
export BUILD_NUMBER=20160311
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := cnt_defconfig
endif

TARGET_RECOVERY_FSTAB := device/boundary/cnt/fstab.freescale

BOARD_HAS_SGTL5000 := true
USE_CAMERA_STUB := true

BOARD_NOT_HAVE_MODEM := true
BOARD_HAVE_IMX_CAMERA := false
BOARD_HAVE_USB_CAMERA := false
BOARD_HAS_SENSOR := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

TARGET_BOOTLOADER_BOARD_NAME := CNT
PRODUCT_MODEL := CNT

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_TS_CALIBRATION := true

# WiFi/BT common defines
BOARD_HAVE_WIFI         := false
BOARD_HAVE_BLUETOOTH    := false
BOARD_WLAN_DEVICE       := none
WPA_SUPPLICANT_VERSION  := none

include device/boundary/sepolicy.mk

