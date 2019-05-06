# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-

define build_imx_uboot
	$(hide) echo Building i.MX U-Boot with firmware; \
	cd $(IMX_MKIMAGE_PATH)/imx-mkimage/; \
	UBOOT_PATH=../../../$(UBOOT_OUT) UBOOT_DTB=imx8mq-nitrogen8m.dtb SOC=iMX8MQ ./make_boundary.sh; \
	cd -; \
	SZ=$(patsubst %_,,$(strip $(2))); \
	if [ "$$SZ" = "$(strip $(2))" ] ; then \
		SZ=2g; \
	fi; \
	cp -v $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-lpddr4-iMX8MQ-$$SZ.hdmibin $(PRODUCT_OUT)/boot/u-boot.nitrogen8m;
endef


