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

#======================================================================================
# 1.for color_tune_alg ko file copy
#======================================================================================

ifeq ($(strip $(COLOR_TUNE_MODULE)),true)
    $(warning COLOR_TUNE_MODULE is $(COLOR_TUNE_MODULE))
    ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
        ifeq ($(KERNEL_A32_SUPPORT),true)
           PRODUCT_COPY_FILES += \
               device/amlogic/common/video_algorithm/color_tune/32_4_9/color_tune_alg_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/color_tune_alg.ko \
               device/amlogic/common/initscripts/color_tune.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/color_tune.rc
        else
           PRODUCT_COPY_FILES += \
                device/amlogic/common/video_algorithm/color_tune/64_4_9/color_tune_alg_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/color_tune_alg.ko \
                device/amlogic/common/initscripts/color_tune.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/color_tune.rc
        endif
    else
        ifeq ($(KERNEL_A32_SUPPORT),true)
            PRODUCT_COPY_FILES += \
                device/amlogic/common/video_algorithm/color_tune/32/color_tune_alg_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/color_tune_alg.ko \
                device/amlogic/common/initscripts/color_tune.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/color_tune.rc
        else
            PRODUCT_COPY_FILES += \
                device/amlogic/common/video_algorithm/color_tune/64/color_tune_alg_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/color_tune_alg.ko \
                device/amlogic/common/initscripts/color_tune.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/color_tune.rc
        endif
    endif
endif
