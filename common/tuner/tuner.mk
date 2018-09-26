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

#t962_p321 tuner
ifeq ($(PRODUCT_DIR), t962_p321)
ifeq ($(KERNEL_A32_SUPPORT), true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/32/r842_fe_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/r842_fe.ko
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/64/r842_fe_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/r842_fe.ko
endif
endif

#t962e_r321 tuner
ifeq ($(PRODUCT_DIR), darwin)
ifeq ($(KERNEL_A32_SUPPORT), true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/32/si2151_fe_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/si2151_fe.ko
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/64/si2151_fe_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/si2151_fe.ko
endif
endif

#t962x_r311 tuner
ifeq ($(PRODUCT_DIR), einstein)
ifeq ($(KERNEL_A32_SUPPORT), true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/32/mxl661_fe_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/mxl661_fe.ko
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/tuner/64/mxl661_fe_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/mxl661_fe.ko
endif
endif
