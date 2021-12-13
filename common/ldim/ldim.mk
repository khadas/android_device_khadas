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
# 1.for ldim_alg ko file copy
#======================================================================================

ifeq ($(strip $(LDIM_FW_MODULE)),true)
    $(warning LDIM_FW_MODULE is $(LDIM_FW_MODULE))
    ifeq ($(TARGET_BUILD_KERNEL_4_9),true)

    else
        ifeq ($(KERNEL_A32_SUPPORT),true)

        else
            PRODUCT_COPY_FILES += \
                device/khadas/common/ldim/64/ldim_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/ldim_fw.ko \
                device/khadas/common/initscripts/ldim.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/ldim.rc
        endif
    endif
endif
