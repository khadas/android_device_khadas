#
# Copyright (C) 2013 The Android Open-Source Project
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

#########################################################################
#
# Remote config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tv/tl1/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    device/amlogic/common/products/tv/tl1/files/remote.tab1:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab1 \
    device/amlogic/common/products/tv/tl1/files/remote.tab2:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab2 \
    device/amlogic/common/products/tv/tl1/files/remote.tab3:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab3

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tv/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/amlogic/common/products/tv/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

# recovery
PRODUCT_COPY_FILES += \
    device/amlogic/common/recovery/busybox:recovery/root/sbin/busybox \
    device/amlogic/common/products/tv/tl1/recovery/recovery.kl:recovery/root/sbin/recovery.kl \
    device/amlogic/common/products/tv/tl1/recovery/remotecfg:recovery/root/sbin/remotecfg \
    device/amlogic/common/products/tv/tl1/files/remote.cfg:recovery/root/sbin/remote.cfg \
    device/amlogic/common/products/tv/tl1/files/remote.tab1:recovery/root/sbin/remote.tab1 \
    device/amlogic/common/products/tv/tl1/files/remote.tab2:recovery/root/sbin/remote.tab2 \
    device/amlogic/common/products/tv/tl1/files/remote.tab3:recovery/root/sbin/remote.tab3 \
    device/amlogic/common/products/tv/tl1/recovery/sh:recovery/root/sbin/sh

#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tv/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

PRODUCT_COPY_FILES += device/amlogic/common/products/tv/ueventd.amlogic.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

ifneq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/recovery/init.recovery.amlogic.rc:root/init.recovery.amlogic.rc
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/recovery/init.recovery.amlogic_ab.rc:root/init.recovery.amlogic.rc
endif

#########################################################################
#
# Media codec
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tv/tl1/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/amlogic/common/products/tv/tl1/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml



# tv config file
ifneq ($(BOARD_USES_ODM_EXTIMAGE),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/amlogic/common/products/tv/tl1/files/tv/tvconfig/,/$(TARGET_COPY_OUT_ODM)/etc/tvconfig) \
    device/amlogic/common/products/tv/tl1/files/tv/dec:$(TARGET_COPY_OUT_ODM)/bin/dec \
    device/amlogic/common/products/tv/tl1/files/PQ/pq.db:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq.db \
    device/amlogic/common/products/tv/tl1/files/PQ/overscan.db:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/overscan.db \
    device/amlogic/common/products/tv/tl1/files/PQ/pq_default.ini:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq_default.ini
else
TVCONFIG_FILES := \
    device/amlogic/common/products/tv/tl1/files/tv/tvconfig/*
PQ_FILES := \
    device/amlogic/common/products/tv/tl1/files/PQ/pq.db \
    device/amlogic/common/products/tv/tl1/files/PQ/overscan.db \
    device/amlogic/common/products/tv/tl1/files/PQ/pq_default.ini
endif

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp


#########################################################################
#
## Amazon Prime
#
##########################################################################
PRODUCT_COPY_FILES += \
	device/amlogic/common/amazon/prime.xml:system/etc/permissions/prime.xml
#########################################################################
#
# Audio
#
#########################################################################

ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
AUDIO_FEATURE_TYPE :=
ifeq ($(TARGET_BUILD_DOLBY_MS12_V2),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ms12
endif

ifeq ($(TARGET_BUILD_DOLBY_MS12_V1),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ms12_v1
endif

ifeq ($(TARGET_BUILD_DOLBY_DDP),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ddp
endif

ifeq ($(TARGET_BUILD_DTSHD),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_dtshd
endif

PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'using audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml')

endif  ###end USE_XML_AUDIO_POLICY_CONF
