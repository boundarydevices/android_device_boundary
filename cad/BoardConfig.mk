#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
export BUILD_ID=4.4.2_1.0.0-ga
export BUILD_NUMBER=20140908
include device/fsl/imx6/BoardConfigCommon.mk

ifneq ($(DEFCONF),)
TARGET_KERNEL_DEFCONF := $(DEFCONF)
else
TARGET_KERNEL_DEFCONF := cad_defconfig
endif

TARGET_RECOVERY_FSTAB := device/boundary/cad/fstab.boundary

BOARD_HAS_SGTL5000 := true
BOARD_HAVE_BLUETOOTH := false
USE_CAMERA_STUB := false
BOARD_CAMERA_LIBRARIES := libcamera

BOARD_HAVE_WIFI := false

BOARD_HAVE_MODEM := false
BOARD_HAVE_IMX_CAMERA := true
BOARD_HAVE_USB_CAMERA := false
BOARD_HAS_SENSOR := false
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

PRODUCT_MODEL := CAD

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_TS_CALIBRATION := false

BOARD_USE_AR3K_BLUETOOTH := 
SKIP_WPA_SUPPLICAN_CONF		 := y
SKIP_WPA_SUPPLICANT_RTL		 := y
BOARD_WLAN_DEVICE                := none
