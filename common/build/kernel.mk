#
# Copyright 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Targets for builing kernels
#
# The following must be set before including this file:
# KERNEL_IMX_PATH must be set the base of a kernel tree.
# TARGET_KERNEL_DEFCONFIG must name a base kernel config.
# TARGET_KERNEL_ARCH must be set to match kernel arch.
#
# The following maybe set:
# TARGET_KERNEL_CROSS_COMPILE_PREFIX to override toolchain.
# TARGET_KERNEL_CONFIGS to specify a set of additional kernel config files.

# Brillo does not support prebuilt kernels.
ifneq ($(TARGET_PREBUILT_KERNEL),)
$(error TARGET_PREBUILT_KERNEL defined but Brillo kernels build from source)
endif

ifeq ($(KERNEL_IMX_PATH),)
$(error KERNEL_IMX_PATH not defined)
endif

ifeq ($(TARGET_KERNEL_DEFCONFIG),)
$(error TARGET_KERNEL_DEFCONFIG not defined)
endif

ifeq ($(TARGET_KERNEL_ARCH),)
$(error TARGET_KERNEL_ARCH not defined)
endif

# Check target arch.
KERNEL_TOOLCHAIN_ABS := $(realpath $(TARGET_TOOLCHAIN_ROOT)/bin)
TARGET_KERNEL_ARCH := $(strip $(TARGET_KERNEL_ARCH))
KERNEL_ARCH := $(TARGET_KERNEL_ARCH)
KERNEL_CC_WRAPPER := $(CC_WRAPPER)
KERNEL_AFLAGS :=
TARGET_KERNEL_SRC := $(KERNEL_IMX_PATH)/kernel_imx

ifeq ($(TARGET_KERNEL_ARCH), arm)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/arm-linux-androidkernel-
KERNEL_SRC_ARCH := arm
KERNEL_CFLAGS :=
KERNEL_NAME := zImage
else ifeq ($(TARGET_KERNEL_ARCH), arm64)
# Override the toolchain for arm64 and make it explict. This allows
# for a 64bit kernel and 32bit userspace. Currently this is arm64 only.
KERNEL_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-
KERNEL_SRC_ARCH := arm64
KERNEL_CFLAGS :=
KERNEL_NAME ?= Image.gz
else
$(error kernel arch not supported at present)
endif

# Allow caller to override toolchain.
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(TARGET_KERNEL_CROSS_COMPILE_PREFIX))
ifneq ($(TARGET_KERNEL_CROSS_COMPILE_PREFIX),)
KERNEL_CROSS_COMPILE := $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)
endif

# Use ccache if requested by USE_CCACHE variable
KERNEL_CROSS_COMPILE_WRAPPER := $(realpath $(KERNEL_CC_WRAPPER)) $(KERNEL_CROSS_COMPILE)

KERNEL_GCC_NOANDROID_CHK := $(shell (echo "int main() {return 0;}" | $(KERNEL_CROSS_COMPILE)gcc -E -mno-android - > /dev/null 2>&1 ; echo $$?))
ifeq ($(strip $(KERNEL_GCC_NOANDROID_CHK)),0)
KERNEL_CFLAGS += -mno-android
KERNEL_AFLAGS += -mno-android
endif

# Set the output for the kernel build products.
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_BIN := $(KERNEL_OUT)/arch/$(KERNEL_SRC_ARCH)/boot/$(KERNEL_NAME)

# Figure out which kernel version is being built (disregard -stable version).
KERNEL_VERSION := $(shell PATH=$$PATH $(MAKE) --no-print-directory -C $(TARGET_KERNEL_SRC) -s SUBLEVEL="" kernelversion)

# Brillo kernel config file sources.
KERNEL_CONFIG_DEFAULT := $(TARGET_KERNEL_SRC)/arch/$(KERNEL_SRC_ARCH)/configs/$(TARGET_KERNEL_DEFCONFIG)
ifneq ($(TARGET_KERNEL_ADDITION_DEFCONF),)
KERNEL_CONFIG_ADDITION := $(TARGET_DEVICE_DIR)/$(TARGET_KERNEL_ADDITION_DEFCONF)
else
KERNEL_CONFIG_ADDITION :=
endif
KERNEL_CONFIG_SRC := $(KERNEL_CONFIG_DEFAULT) \
  $(KERNEL_CONFIG_ADDITION)
KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_MERGE_CONFIG := device/fsl/common/tools/mergeconfig.sh

KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
#KERNEL_MODULES_INSTALL := $(TARGET_OUT)/lib/modules
KERNEL_MODULES_INSTALL := $(BOARD_VENDOR_KERNEL_MODULES)

KERNEL_FIRMWARE_DIR_CONFIG := $(KERNEL_OUT)/firmware.kconf

$(KERNEL_FIRMWARE_DIR_CONFIG):
	$(hide) echo CONFIG_EXTRA_FIRMWARE_DIR="\"$(TARGET_KERNEL_EXTRA_FIRMWARE_DIR)\"" > $@

ifdef TARGET_KERNEL_EXTRA_FIRMWARE_DIR
KERNEL_CONFIG_SRC += $(KERNEL_FIRMWARE_DIR_CONFIG)
endif

$(KERNEL_OUT):
	mkdir -p $@

# Merge the required kernel config elements into a single file.
$(KERNEL_CONFIG_REQUIRED): $(KERNEL_CONFIG_REQUIRED_SRC) | $(KERNEL_OUT)
	$(hide) cat $^ > $@

# Merge the final target kernel config.
$(KERNEL_CONFIG): $(KERNEL_CONFIG_SRC) | $(KERNEL_OUT)
	$(hide) echo Merging KERNEL config
	$(KERNEL_MERGE_CONFIG) $(TARGET_KERNEL_SRC) $(realpath $(KERNEL_OUT)) \
	$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $^

# Disable CCACHE_DIRECT so that header location changes are noticed.
define build_kernel
	PATH=$$(cd prebuilts/misc/linux-x86/lz4; pwd):$$PATH \
		CCACHE_NODIRECT="true" $(MAKE) -C $(TARGET_KERNEL_SRC) \
		O=$(realpath $(KERNEL_OUT)) \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE="$(KERNEL_CROSS_COMPILE_WRAPPER)" \
		KCFLAGS="$(KERNEL_CFLAGS)" \
		KAFLAGS="$(KERNEL_AFLAGS)" \
		$(1)
endef

$(KERNEL_BIN): $(KERNEL_CONFIG) $(TARGET_KERNEL_SRC) | $(KERNEL_OUT)
	$(hide) echo "Building $(KERNEL_ARCH) $(KERNEL_VERSION) kernel ..."
	$(hide) PATH=$$PATH $(MAKE) -C $(TARGET_KERNEL_SRC) mrproper
	$(call build_kernel,$(KERNEL_NAME))
	$(call build_kernel,modules)

$(KERNEL_OUT)/vmlinux: $(KERNEL_BIN)
	@true

$(KERNEL_MODULES_INSTALL): $(KERNEL_BIN)
	$(hide) echo "Installing kernel modules ..."

$(KERNEL_HEADERS_INSTALL): $(KERNEL_BIN)
	$(hide) echo "Installing kernel headers ..."
	$(call build_kernel,headers_install)

# If the kernel generates VDSO files, generate breakpad symbol files for them.
# VDSO libraries are mapped as linux-gate.so, so rename the symbol file to
# match as well as the filename in the first line of the .sym file.
.PHONY: $(KERNEL_BIN).vdso
$(KERNEL_BIN).vdso: $(KERNEL_BIN) $(BREAKPAD_DUMP_SYMS)
ifeq ($(BREAKPAD_GENERATE_SYMBOLS),true)
	$(hide) echo "BREAKPAD: Generating kernel VDSO symbol files."
	$(hide) set -e; \
	for sofile in `cd $(KERNEL_OUT) && find . -type f -name '*.so'`; do \
		mkdir -p $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}; \
		$(BREAKPAD_DUMP_SYMS) -c $(KERNEL_OUT)/$${sofile} > $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym; \
		sed -i.tmp "1s/`basename "$${sofile}"`/linux-gate.so/" $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym; \
		rm $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym.tmp; \
	done
endif

# The list of dependencies for the final kernel.
KERNEL_DEPS := $(KERNEL_BIN).vdso $(KERNEL_HEADERS_INSTALL) $(KERNEL_MODULES_INSTALL)
KERNEL_IMAGE := $(KERNEL_BIN)

# Makes sure any built modules will be included in the system image build.
ALL_DEFAULT_INSTALLED_MODULES += $(KERNEL_MODULES_INSTALL)

# Produces the actual kernel image!
$(PRODUCT_OUT)/kernel: $(KERNEL_IMAGE) $(KERNEL_DEPS) | $(ACP)
	$(ACP) -fp $< $@

KERNEL_OUT/usr: $(PRODUCT_OUT)/kernel
