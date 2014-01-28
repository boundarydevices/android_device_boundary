BOOTSCRIPT_TARGET := $(PRODUCT_OUT)/boot/6x_bootscript
$(BOOTSCRIPT_TARGET): device/boundary/$(TARGET_BOOTLOADER_DIR)/6x_bootscript_jb.txt $(TOPDIR)bootable/bootloader/uboot-imx/tools/mkimage
	mkdir -p $(dir $@)
	$(TOPDIR)bootable/bootloader/uboot-imx/tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot script" -d $< $@

UPGRADE_TARGET := $(PRODUCT_OUT)/boot/6x_upgrade
$(UPGRADE_TARGET): bootable/bootloader/uboot-imx/board/boundary/nitrogen6x/6x_upgrade.txt $(TARGET_BOOTLOADER_IMAGE)
	mkdir -p $(dir $@)
	$(TOPDIR)bootable/bootloader/uboot-imx/tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot loader upgrade script" -d $< $@

.PHONY: bootscript
bootscript: $(BOOTSCRIPT_TARGET) $(UPGRADE_TARGET) $(TARGET_BOOTLOADER_IMAGE)

droidcore: bootscript

