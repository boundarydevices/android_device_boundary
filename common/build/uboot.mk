#
# Copyright 2017 The Android Open Source Project
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
#Copyright 2017 NXP

# Targets for building U-Boot
#
# The following must be set before including this file:
# UBOOT_IMX_PATH must be set the base of a U-Boot tree.
# TARGET_BOOTLOADER_CONFIG must name a base U-Boot config.
# TARGET_UBOOT_ARCH must be set to match U-Boot arch.
#
# The following may be set:
# TARGET_UBOOT_CROSS_COMPILE_PREFIX to override toolchain.
# TARGET_UBOOT_CONFIGS to specify a set of additional U-Boot config files.
# TARGET_UBOOT_ENV to specify an environment to be compiled into uboot.env.
# TARGET_UBOOT_ENV_SIZE to specify the size reserved in U-Boot for the env.

ifeq ($(UBOOT_IMX_PATH),)
$(error UBOOT_IMX_PATH not defined but uboot.mk included)
endif

ifeq ($(TARGET_BOOTLOADER_CONFIG),)
$(error TARGET_BOOTLOADER_CONFIG not defined)
endif

ifeq ($(TARGET_UBOOT_ARCH),)
$(error TARGET_UBOOT_ARCH not defined)
endif

ifeq ($(TARGET_UBOOT_ENV_SIZE),)
ifneq ($(TARGET_UBOOT_ENV),)
$(error If TARGET_UBOOT_ENV is set TARGET_UBOOT_ENV_SIZE must also be set. See\
 CONFIG_ENV_SIZE in the selected U-Boot board config file.)
endif
endif

# Check if we can sign u-boot image.
# For this CST_BIN, SIGN_KEY, IMG_KEY and SRK_TABLE must all be defined.
ifneq ($(and $(CST_BIN),$(SIGN_KEY),$(IMG_KEY),$(SRK_TABLE)),)
$(info u-boot will be signed)
UBOOT_SIGN := true
endif

# TARGET_UBOOT_BUILD_TARGET may be assigned in target BoardConfig.mk.
TARGET_UBOOT_BUILD_TARGET ?= u-boot.imx

# Check target arch.
TARGET_UBOOT_ARCH := $(strip $(TARGET_UBOOT_ARCH))
UBOOT_ARCH := $(TARGET_UBOOT_ARCH)
UBOOT_CC_WRAPPER := $(CC_WRAPPER)
UBOOT_AFLAGS :=
UBOOT_DTC_ABS := $(realpath prebuilts/misc/linux-x86/dtc/dtc)


ifeq ($(TARGET_UBOOT_ARCH), arm)
ifneq ($(AARCH32_GCC_CROSS_COMPILE),)
UBOOT_CROSS_COMPILE := $(strip $(AARCH32_GCC_CROSS_COMPILE))
else
$(error shell env AARCH32_GCC_CROSS_COMPILE is not set)
endif
UBOOT_SRC_ARCH := arm
UBOOT_CFLAGS :=

else ifeq ($(TARGET_UBOOT_ARCH), arm64)
ifneq ($(AARCH64_GCC_CROSS_COMPILE),)
UBOOT_CROSS_COMPILE := $(strip $(AARCH64_GCC_CROSS_COMPILE))
else
$(error shell env AARCH64_GCC_CROSS_COMPILE is not set)
endif
UBOOT_SRC_ARCH := arm64
UBOOT_CFLAGS :=
else
$(error U-boot arch not supported at present)
endif


# Allow caller to override toolchain.
TARGET_UBOOT_CROSS_COMPILE_PREFIX := $(strip $(TARGET_UBOOT_CROSS_COMPILE_PREFIX))
ifneq ($(TARGET_UBOOT_CROSS_COMPILE_PREFIX),)
UBOOT_CROSS_COMPILE := $(TARGET_UBOOT_CROSS_COMPILE_PREFIX)
endif

# Use ccache if requested by USE_CCACHE variable
UBOOT_CROSS_COMPILE_WRAPPER := $(realpath $(UBOOT_CC_WRAPPER)) $(UBOOT_CROSS_COMPILE)

UBOOT_GCC_NOANDROID_CHK := $(shell (echo "int main() {return 0;}" | $(UBOOT_CROSS_COMPILE)gcc -E -mno-android - > /dev/null 2>&1 ; echo $$?))
ifeq ($(strip $(UBOOT_GCC_NOANDROID_CHK)),0)
UBOOT_CFLAGS += -mno-android
UBOOT_AFLAGS += -mno-android
endif

# Set the output for the U-Boot build products.
UBOOT_OUT := $(TARGET_OUT_INTERMEDIATES)/UBOOT_OBJ
UBOOT_COLLECTION := $(TARGET_OUT_INTERMEDIATES)/UBOOT_COLLECTION
UBOOT_BIN := $(PRODUCT_OUT)/$(TARGET_UBOOT_BUILD_TARGET)
UBOOT_ENV_OUT := $(PRODUCT_OUT)/uboot.env

export UBOOT_OUT
export UBOOT_COLLECTION

# Figure out which U-Boot version is being built (disregard -stable version).
UBOOT_VERSION := $(shell $(MAKE) -j1 --no-print-directory -C $(UBOOT_IMX_PATH)/uboot-imx -s SUBLEVEL="" ubootversion)

$(UBOOT_COLLECTION) $(UBOOT_OUT):
	mkdir -p $@

UBOOTENVSH := $(UBOOT_OUT)/ubootenv.sh
$(UBOOTENVSH): | $(UBOOT_OUT)
	rm -rf $@
	if [ -n "$(BOOTLOADER_RBINDEX)" ]; then \
		echo 'export ROLLBACK_INDEX_IN_FIT=$(BOOTLOADER_RBINDEX)' > $@; \
		echo 'export ROLLBACK_INDEX_IN_CONTAINER=$(BOOTLOADER_RBINDEX)' >> $@; \
	else \
		echo 'export ROLLBACK_INDEX_IN_FIT=' > $@; \
		echo 'export ROLLBACK_INDEX_IN_CONTAINER=' >> $@; \
	fi

$(UBOOT_BIN): $(UBOOTENVSH) | $(UBOOT_COLLECTION) $(UBOOT_OUT)
	$(hide) echo "Building $(UBOOT_ARCH) $(UBOOT_VERSION) U-Boot ..."
	$(hide) $(call build_m4_image)
	$(hide) for ubootplat in $(TARGET_BOOTLOADER_CONFIG); do \
		UBOOT_PLATFORM=`echo $$ubootplat | cut -d':' -f1`; \
		UBOOT_CONFIG=`echo $$ubootplat | cut -d':' -f2`; \
		if [ ${clean_build} = 1 ]; then \
			$(MAKE) -C $(UBOOT_IMX_PATH)/uboot-imx/ CROSS_COMPILE="$(UBOOT_CROSS_COMPILE_WRAPPER)" O=$(realpath $(UBOOT_OUT)) mrproper; \
		fi; \
		$(MAKE) -C $(UBOOT_IMX_PATH)/uboot-imx/ CROSS_COMPILE="$(UBOOT_CROSS_COMPILE_WRAPPER)" O=$(realpath $(UBOOT_OUT)) $$UBOOT_CONFIG; \
		$(MAKE) -s -C $(UBOOT_IMX_PATH)/uboot-imx/ CROSS_COMPILE="$(UBOOT_CROSS_COMPILE_WRAPPER)" O=$(realpath $(UBOOT_OUT)) || exit 1; \
		if [ "$(UBOOT_POST_PROCESS)" = "true" ]; then \
			echo "build post process" ; \
			. $(UBOOTENVSH); \
		    $(call build_imx_uboot, $(TARGET_BOOTLOADER_POSTFIX), $$UBOOT_PLATFORM) \
		    echo "===================Finish building `echo $$ubootplat | cut -d':' -f2` ==================="; \
		else \
			install -D $(UBOOT_OUT)/u-boot$(TARGET_DTB_POSTFIX).$(TARGET_BOOTLOADER_POSTFIX) $(UBOOT_COLLECTION)/u-boot-$$UBOOT_PLATFORM.imx; \
		fi; \
		if [ "$(PRODUCT_IMX_DRM)" = "true" ]; then \
		    echo "build post process with tee" ; \
		    $(call build_uboot_w_tee,  $(TARGET_BOOTLOADER_POSTFIX), $$UBOOT_PLATFORM) \
		fi; \
		install -D $(UBOOT_COLLECTION)/flash.bin $(UBOOT_BIN); \
		UBOOT_BD_NAME=`echo u-boot.$$UBOOT_CONFIG | sed 's/_defconfig//'`; \
		install -D $(UBOOT_COLLECTION)/flash.bin $(PRODUCT_OUT)/preboot/$$UBOOT_BD_NAME; \
		if [ "$(UBOOT_SIGN)" = "true" ]; then \
			echo "Signing $$UBOOT_BD_NAME"; \
			cd $(UBOOT_OUT); \
			$(ANDROID_BUILD_TOP)/$(UBOOT_IMX_PATH)/uboot-imx/sign_hab_imx8m.sh; \
			cd -; \
			install -D $(UBOOT_OUT)/signed_flash.bin $(PRODUCT_OUT)/preboot/$$UBOOT_BD_NAME; \
		fi; \
	done

.PHONY: bootloader $(UBOOT_BIN) $(UBOOTENVSH)

bootloader: $(UBOOT_BIN)

ifneq ($(TARGET_UBOOT_ENV),)
$(UBOOT_ENV_OUT): $(TARGET_UBOOT_ENV) | $(UBOOT_BIN)
	$(UBOOT_OUT)/tools/mkenvimage -s $(TARGET_UBOOT_ENV_SIZE) -o $@ $<
endif

