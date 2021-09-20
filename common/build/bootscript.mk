ifeq ($(BOARD_HAVE_PREBOOTIMAGE),true)
ifeq ($(BOARD_SOC_CLASS),IMX6)
BOOTSCRIPT_ARCH := arm
else
BOOTSCRIPT_ARCH := arm64
endif

MKIMAGE := $(PRODUCT_OUT)/obj/UBOOT_OBJ/tools/mkimage

BOOTSCRIPT_TARGET := $(PRODUCT_OUT)/preboot/boot.scr
$(BOOTSCRIPT_TARGET): $(LOCAL_PATH)/bootscript.txt $(MKIMAGE)
	mkdir -p $(dir $@)
	$(MKIMAGE) -A $(BOOTSCRIPT_ARCH) -O linux -T script -C none -a 0 -e 0 -n "boot script" -d $< $@

UPGRADE_TARGET := $(PRODUCT_OUT)/preboot/upgrade.scr
$(UPGRADE_TARGET): $(UBOOT_IMX_PATH)/uboot-imx/board/boundary/bootscripts/upgrade.txt $(MKIMAGE)
	mkdir -p $(dir $@)
	$(MKIMAGE) -A $(BOOTSCRIPT_ARCH) -O linux -T script -C none -a 0 -e 0 -n "upgrade script" -d $< $@

.PHONY: bootscript
bootscript: $(BOOTSCRIPT_TARGET) $(UPGRADE_TARGET)

droidcore: bootscript
bootimage: bootscript
endif
