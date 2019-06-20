define build_uboot
	cp -v out/target/product/nitrogen8m/obj/BOOTLOADER_OBJ/u-boot-nodtb.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v out/target/product/nitrogen8m/obj/BOOTLOADER_OBJ/spl/u-boot-spl.bin  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v out/target/product/nitrogen8m/obj/BOOTLOADER_OBJ/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/mkimage_uboot; \
	cp -v out/target/product/nitrogen8m/obj/BOOTLOADER_OBJ/arch/arm/dts/imx8mq-nitrogen8m.dtb  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/signed_hdmi_imx8m.bin  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_1d_dmem.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_1d_imem.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_2d_dmem.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_2d_imem.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp -v $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
	SZ=$(patsubst %_,,$(strip $(2))); \
	if [ "$$SZ" = "$(strip $(2))" ] ; then \
		SZ=2g; \
	fi; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=iMX8M DTBS=imx8mq-nitrogen8m.dtb u-boot-lpddr4-$$SZ.hdmibin; \
	cp -v $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-lpddr4-$$SZ.hdmibin $(PRODUCT_OUT)/boot/u-boot.$(strip $(2));
endef
