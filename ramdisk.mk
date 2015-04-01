RAMDISK_TARGET := $(PRODUCT_OUT)/boot/uramdisk.img
$(RAMDISK_TARGET): $(PRODUCT_OUT)/ramdisk.img kernelmodules
	mkdir -p $(dir $@)
	mkimage -A arm -O linux -T ramdisk -n "RAM Disk" -d $< $@

RAMDISK_RECOVERY_TARGET := $(PRODUCT_OUT)/uramdisk-recovery.img
$(RAMDISK_RECOVERY_TARGET): $(PRODUCT_OUT)/recovery.img
	mkdir -p $(dir $@)
	mkimage -A arm -O linux -T ramdisk -n "RAM Disk" -d $(PRODUCT_OUT)/ramdisk-recovery.img $@

droidcore: $(RAMDISK_TARGET) $(RAMDISK_RECOVERY_TARGET)
bootimage: $(RAMDISK_TARGET) $(RAMDISK_RECOVERY_TARGET)

