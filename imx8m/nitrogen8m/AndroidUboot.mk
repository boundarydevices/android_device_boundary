# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-

define build_imx_uboot
	$(hide) echo Building i.MX U-Boot with firmware; \
	cd $(IMX_MKIMAGE_PATH)/imx-mkimage/; \
	SZ="2g"; \
	isSom=false; \
	if [[ $3 =~ "som" ]]; then \
		isSom=true; \
	fi; \
	if [[ $3 =~ "3g" ]]; then \
		SZ="3g"; \
	elif [[ $3 =~ "4g" ]]; then \
		SZ="4g"; \
	fi; \
	if [ $$isSom = true ]; then \
		UBOOT_PATH=../../../$(UBOOT_OUT) UBOOT_DTB=imx8mq-nitrogen8m_som.dtb SOC=iMX8MQ ./make_boundary.sh $$SZ; \
		cd -; \
		cp -v $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-lpddr4-iMX8MQ-$$SZ.hdmibin $(PRODUCT_OUT)/boot/u-boot.nitrogen8m_som_$$SZ; \
	else \
		UBOOT_PATH=../../../$(UBOOT_OUT) UBOOT_DTB=imx8mq-nitrogen8m.dtb SOC=iMX8MQ ./make_boundary.sh $$SZ; \
		cd -; \
		if [ $$SZ = "2g" ]; then \
			cp -v $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-lpddr4-iMX8MQ-$$SZ.hdmibin $(PRODUCT_OUT)/boot/u-boot.nitrogen8m; \
		else \
			cp -v $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-lpddr4-iMX8MQ-$$SZ.hdmibin $(PRODUCT_OUT)/boot/u-boot.nitrogen8m_$$SZ; \
		fi; \
	fi;
endef


