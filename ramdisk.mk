ifeq ($(BOARD_SOC_CLASS),IMX6)
RAMDISK_ARCH := arm
else
RAMDISK_ARCH := arm64
endif

RAMDISK_TARGET := $(PRODUCT_OUT)/boot/uramdisk.img
$(RAMDISK_TARGET): $(PRODUCT_OUT)/ramdisk.img kernelmodules
	mkdir -p $(dir $@)
	mkimage -A $(RAMDISK_ARCH) -O linux -T ramdisk -n "RAM Disk" -d $< $@

bootimage: $(RAMDISK_TARGET)
