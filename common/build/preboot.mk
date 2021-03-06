ifeq ($(BOARD_HAVE_PREBOOTIMAGE),true)
INSTALLED_PREBOOTIMAGE_TARGET := $(PRODUCT_OUT)/preboot.img
PREBOOT_BINARY_PATHS := $(HOST_OUT_EXECUTABLES)

.PHONY: preboot
preboot: $(MKEXTUSERIMG) $(BOOTSCRIPT_TARGET) $(UPGRADE_TARGET)
	$(call pretty,"Target preboot image: $(INSTALLED_PREBOOTIMAGE_TARGET)")
	PATH=$(PREBOOT_BINARY_PATHS):$$PATH $(MKEXTUSERIMG) $(INTERNAL_USERIMAGES_SPARSE_EXT_FLAG) $(PRODUCT_OUT)/preboot $(INSTALLED_PREBOOTIMAGE_TARGET) ext4 preboot $(BOARD_PREBOOTIMAGE_PARTITION_SIZE) -L preboot

droidcore: preboot
bootimage: preboot
endif
