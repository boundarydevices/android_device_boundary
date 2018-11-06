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

#r840 tuner
ifeq ($(TUNER_MODULE), r840)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/r840_fe.ko
endif

#r842 tuner
ifeq ($(TUNER_MODULE), r842)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/r842_fe.ko
endif

#si2151 tuner
ifeq ($(TUNER_MODULE), si2151)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/si2151_fe.ko
endif

#si2159 tuner
ifeq ($(TUNER_MODULE), si2159)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/si2159_fe.ko
endif

#mxl661 tuner
ifeq ($(TUNER_MODULE), mxl661)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/mxl661_fe.ko
endif

#atbm8881
ifeq ($(TUNER_MODULE), atbm8881)
BOARD_VENDOR_KERNEL_MODULES += \
	$(PRODUCT_OUT)/obj/lib_vendor/atbm8881_fe.ko
endif