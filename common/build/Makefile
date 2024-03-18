# below variables are defined in AOSP build makefile, to build kernel independently, redefine them here
hide := @

PRODUCT_OUT := ${OUT}
TARGET_OUT_INTERMEDIATES := $(PRODUCT_OUT)/obj
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

export PRODUCT_OUT
export TARGET_OUT_INTERMEDIATES

# firstly to include UbootKernelCommonConfig.mk, then SharedBoardConfig.mk, finally UbootKernelBoardConfig.mk

include ${nxp_git_path}/common/imx_path/ImxPathConfig.mk
include ${soc_path}/UbootKernelCommonConfig.mk
include ${product_path}/SharedBoardConfig.mk
include ${product_path}/UbootKernelBoardConfig.mk

include ${nxp_git_path}/common/build/kernel.mk
include ${nxp_git_path}/common/build/uboot.mk
-include ${product_path}/AndroidUboot.mk
-include ${product_path}/AndroidTee.mk
-include ${GPU_VIV6_PATH}/gpu-viv6/driver/hal/kernel/galcore.mk
-include ${VVCAM_PATH}/vvcam/vvcam.mk
-include ${MXMWIFI_PATH}/mxm_wifiex/mxmwifi.mk
