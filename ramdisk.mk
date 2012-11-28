RAMDISK_TARGET := $(PRODUCT_OUT)/boot/uramdisk.img
$(RAMDISK_TARGET): $(PRODUCT_OUT)/ramdisk.img
	mkdir -p $(dir $@)
	mkimage -A arm -O linux -T ramdisk -n "RAM Disk" -d $< $@

.PHONY: ramdisk
ramdisk: $(RAMDISK_TARGET)

droidcore: ramdisk

