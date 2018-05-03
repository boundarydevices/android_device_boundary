ifeq ($(BOARD_SOC_CLASS),IMX6)
BOARD_SEPOLICY_DIRS := \
       device/boundary/sepolicy \
       device/fsl/imx6/sepolicy
else
BOARD_SEPOLICY_DIRS := \
       device/boundary/sepolicy \
       device/fsl/imx8/sepolicy
endif
