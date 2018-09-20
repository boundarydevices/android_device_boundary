#if use probuilt kernel or build kernel from source code

KERNEL_ROOTDIR := common
KERNEL_KO_OUT := $(PRODUCT_OUT)/obj/lib_vendor

INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET)

INSTALLED_2NDBOOTLOADER_TARGET := $(PRODUCT_OUT)/2ndbootloader

ifneq ($(TARGET_KERNEL_BUILT_FROM_SOURCE), true)
TARGET_PREBUILT_KERNEL := device/amlogic/darwin-kernel/Image.gz
INSTALLED_BOARDDTB_TARGET := $(PRODUCT_OUT)/dt.img
LOCAL_DTB := device/amlogic/darwin-kernel/darwin.dtb

$(TARGET_PREBUILT_KERNEL): $(INSTALLED_BOARDDTB_TARGET)
	@echo "cp kernel modules"
	mkdir -p $(PRODUCT_OUT)/root/boot
	mkdir -p $(PRODUCT_OUT)/vendor/lib/firmware/video
	mkdir -p $(PRODUCT_OUT)/obj/lib
	mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/
	mkdir -p $(PRODUCT_OUT)/recovery/root/boot
	mkdir -p $(KERNEL_KO_OUT)
	cp device/amlogic/darwin-kernel/lib/mali.ko $(PRODUCT_OUT)/vendor/lib/
	cp device/amlogic/darwin-kernel/lib/modules/* $(KERNEL_KO_OUT)/
	cp device/amlogic/darwin-kernel/lib/optee_armtz.ko $(PRODUCT_OUT)/vendor/lib/
	cp device/amlogic/darwin-kernel/lib/optee.ko $(PRODUCT_OUT)/vendor/lib/
	-cp device/amlogic/darwin-kernel/lib/si2151_fe.ko $(PRODUCT_OUT)/vendor/lib/
	cp device/amlogic/darwin-kernel/lib/firmware/video/* $(PRODUCT_OUT)/vendor/lib/firmware/video/
	-cp device/amlogic/darwin-kernel/obj/KERNEL_OBJ/vmlinux $(PRODUCT_OUT)/obj/KERNEL_OBJ/
	mkdir -p $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/lib/modules/
	cp $(KERNEL_KO_OUT)/* $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/lib/modules/
	mkdir -p $(PRODUCT_OUT)/vendor/lib/egl
	cp device/amlogic/darwin-kernel/lib/egl/* $(PRODUCT_OUT)/vendor/lib/egl/

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)

$(INSTALLED_BOARDDTB_TARGET): $(LOCAL_DTB) | $(ACP)
	@echo "dtb installed"
	$(transform-prebuilt-to-target)

$(INSTALLED_2NDBOOTLOADER_TARGET): $(INSTALLED_BOARDDTB_TARGET) | $(ACP)
	@echo "2ndbootloader installed"
	$(transform-prebuilt-to-target)

else

-include device/amlogic/common/gpu.mk
-include device/amlogic/common/media_modules.mk
-include device/amlogic/common/wifi_modules.mk

KERNEL_DEVICETREE := txlx_t962e_r321
KERNEL_DEFCONFIG := meson64_defconfig
KERNEL_ARCH := arm64

WIFI_MODULE := multiwifi

KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
INTERMEDIATES_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image.gz
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image_recovery

BOARD_VENDOR_KERNEL_MODULES := \
	$(PRODUCT_OUT)/obj/lib_vendor/audio_data.ko \
	$(PRODUCT_OUT)/obj/lib_vendor/ddr_window_64.ko

BOARD_VENDOR_KERNEL_MODULES	+= $(DEFAULT_MEDIA_KERNEL_MODULES)
BOARD_VENDOR_KERNEL_MODULES     += $(DEFAULT_WIFI_KERNEL_MODULES)

WIFI_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/wifi

PREFIX_CROSS_COMPILE=/opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

define cp-modules
	mkdir -p $(PRODUCT_OUT)/root/boot
	mkdir -p $(KERNEL_KO_OUT)
	-cp $(KERNEL_OUT)/drivers/usb/dwc3/dwc3.ko $(KERNEL_KO_OUT)/
	-cp $(KERNEL_OUT)/drivers/amlogic/usb/dwc_otg/310/dwc_otg.ko $(KERNEL_KO_OUT)/
#	cp $(WIFI_OUT)/broadcom/drivers/ap6xxx/broadcm_40181/dhd.ko $(TARGET_OUT)/lib/
#	cp $(KERNEL_OUT)/../hardware/amlogic/pmu/aml_pmu_dev.ko $(TARGET_OUT)/lib/
#	cp $(shell pwd)/hardware/amlogic/thermal/aml_thermal.ko $(TARGET_OUT)/lib/
#	cp $(KERNEL_OUT)/../hardware/amlogic/nand/amlnf/aml_nftl_dev.ko $(PRODUCT_OUT)/root/boot/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)

$(INTERMEDIATES_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG) $(INSTALLED_BOARDDTB_TARGET)
	@echo "make Image"
#	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules Image.gz
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8188eu/rtl8xxx_EU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
#	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/amlogic/thermal/ ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
	#$(gpu-modules)
	$(MAKE) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) -f device/amlogic/common/wifi_driver.mk $(WIFI_MODULE)
	$(cp-modules)
	$(media-modules)
	mkdir -p $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/lib/modules/
	cp $(KERNEL_KO_OUT)/* $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/lib/modules/

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig
	@echo
	@echo Saved to $(KERNEL_OUT)/defconfig
	@echo
	@echo handly merge to "$(KERNEL_ROOTDIR)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)" if need
	@echo

build-modules-quick:
	    $(media-modules)

$(INSTALLED_2NDBOOTLOADER_TARGET): $(PRODUCT_OUT)/dt.img | $(ACP)
	@echo "2ndbootloader installed"
	$(transform-prebuilt-to-target)

$(INSTALLED_KERNEL_TARGET): $(INTERMEDIATES_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)

$(BOARD_VENDOR_KERNEL_MODULES): $(INSTALLED_KERNEL_TARGET)
	@echo "BOARD_VENDOR_KERNEL_MODULES: $(BOARD_VENDOR_KERNEL_MODULES)"


.PHONY: bootimage-quick
bootimage-quick: $(INTERMEDIATES_KERNEL)
	cp -v $(INTERMEDIATES_KERNEL) $(INSTALLED_KERNEL_TARGET)
	out/host/linux-x86/bin/mkbootfs $(PRODUCT_OUT)/root | \
	out/host/linux-x86/bin/minigzip > $(PRODUCT_OUT)/ramdisk.img
	out/host/linux-x86/bin/mkbootimg  --kernel $(INTERMEDIATES_KERNEL) \
		--base 0x0 \
		--kernel_offset 0x1080000 \
		--ramdisk $(PRODUCT_OUT)/ramdisk.img \
		$(BOARD_MKBOOTIMG_ARGS) \
		--output $(PRODUCT_OUT)/boot.img
	ls -l $(PRODUCT_OUT)/boot.img
	echo "Done building boot.img"

.PHONY: recoveryimage-quick
recoveryimage-quick: $(INTERMEDIATES_KERNEL)
	cp -v $(INTERMEDIATES_KERNEL) $(INSTALLED_KERNEL_TARGET)
	out/host/linux-x86/bin/mkbootfs $(PRODUCT_OUT)/recovery/root | \
	out/host/linux-x86/bin/minigzip > $(PRODUCT_OUT)/ramdisk-recovery.img
	out/host/linux-x86/bin/mkbootimg  --kernel $(INTERMEDIATES_KERNEL) \
		--base 0x0 \
		--kernel_offset 0x1080000 \
		--ramdisk $(PRODUCT_OUT)/ramdisk-recovery.img \
		$(BOARD_MKBOOTIMG_ARGS) \
		--output $(PRODUCT_OUT)/recovery.img
	ls -l $(PRODUCT_OUT)/recovery.img
	echo "Done building recovery.img"

.PHONY: kernelconfig

.PHONY: savekernelconfig

endif

$(PRODUCT_OUT)/ramdisk.img: $(INSTALLED_KERNEL_TARGET)
$(PRODUCT_OUT)/system.img: $(INSTALLED_KERNEL_TARGET)
