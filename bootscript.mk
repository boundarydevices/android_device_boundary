ifeq ($(BOARD_SOC_CLASS),IMX6)
BOOTSCRIPT_ARCH := arm
else
BOOTSCRIPT_ARCH := arm64
endif

BOOTSCRIPT_TARGET := $(PRODUCT_OUT)/boot/boot.scr
$(BOOTSCRIPT_TARGET): device/boundary/$(TARGET_PRODUCT)/bootscript.txt
	mkdir -p $(dir $@)
	mkimage -A $(BOOTSCRIPT_ARCH) -O linux -T script -C none -a 0 -e 0 -n "boot script" -d $< $@

UPGRADE_TARGET := $(PRODUCT_OUT)/boot/upgrade.scr
$(UPGRADE_TARGET): $(UBOOT_IMX_PATH)/uboot-imx/board/boundary/bootscripts/upgrade.txt
	mkdir -p $(dir $@)
	mkimage -A $(BOOTSCRIPT_ARCH) -O linux -T script -C none -a 0 -e 0 -n "upgrade script" -d $< $@

.PHONY: bootscript
bootscript: $(BOOTSCRIPT_TARGET) $(UPGRADE_TARGET)

droidcore: bootscript
bootimage: bootscript
