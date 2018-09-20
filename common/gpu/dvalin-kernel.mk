#
# Copyright (C) 2015 The Android Open Source Project
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
#
$(info dvalin kernel begin)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/mali.ko

GPU_TYPE:=dvalin
GPU_ARCH:=bifrost
GPU_DRV_VERSION:=r10p0
GPU_MODS_OUT?=vendor/lib

CUSTOM_IMAGE_MODULES += mali

$(info dvalin kernel include)
ifeq ($(wildcard $(BOARD_AML_VENDOR_PATH)/gpu/gpu-v2.mk),)
ifeq ($(wildcard hardware/arm/gpu/gpu-v2.mk),)
MESON_GPU_DIR=hardware/arm/gpu
include hardware/arm/gpu/gpu-v2.mk
endif
else
MESON_GPU_DIR=$(BOARD_AML_VENDOR_PATH)/gpu
include $(BOARD_AML_VENDOR_PATH)/gpu/gpu-v2.mk
endif
