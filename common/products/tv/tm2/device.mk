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

CHIP_DIR := device/khadas/common/products/tv/tm2

#########################################################################
#
# Remote config
#
#########################################################################
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    $(CHIP_DIR)/files/remote.tab1:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab1 \
    $(CHIP_DIR)/files/remote.tab2:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab2 \
    $(CHIP_DIR)/files/remote.tab3:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab3

PRODUCT_COPY_FILES += \
    device/khadas/common/products/tv/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/khadas/common/products/tv/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

# recovery
PRODUCT_COPY_FILES += \
    device/khadas/common/recovery/busybox:recovery/root/sbin/busybox \
    $(CHIP_DIR)/recovery/recovery.kl:recovery/root/sbin/recovery.kl \
    $(CHIP_DIR)/recovery/remotecfg:recovery/root/sbin/remotecfg \
    $(CHIP_DIR)/files/remote.cfg:recovery/root/sbin/remote.cfg \
    $(CHIP_DIR)/files/remote.tab1:recovery/root/sbin/remote.tab1 \
    $(CHIP_DIR)/files/remote.tab2:recovery/root/sbin/remote.tab2 \
    $(CHIP_DIR)/files/remote.tab3:recovery/root/sbin/remote.tab3 \
    $(CHIP_DIR)/recovery/sh:recovery/root/sbin/sh

#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/common/products/tv/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

PRODUCT_COPY_FILES += device/khadas/common/products/tv/ueventd.amlogic.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

ifneq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    device/khadas/common/recovery/init.recovery.amlogic.rc:root/init.recovery.amlogic.rc
else
PRODUCT_COPY_FILES += \
    device/khadas/common/recovery/init.recovery.amlogic_ab.rc:root/init.recovery.amlogic.rc
endif

#########################################################################
#
# Media codec
#
#########################################################################
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    $(CHIP_DIR)/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml



# tv config file
PRODUCT_COPY_FILES += \
    device/khadas/common/products/tv/tm2/files/tv/dec:$(TARGET_COPY_OUT_ODM)/bin/dec

# tv config file
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig/*
PQ_FILES := \
    $(CHIP_DIR)/files/PQ/pq.db \
    $(CHIP_DIR)/files/PQ/overscan.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp


#########################################################################
#
## Amazon Prime
#
##########################################################################
PRODUCT_COPY_FILES += \
	device/khadas/common/amazon/prime.xml:system/etc/permissions/prime.xml


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
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'using audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml')

endif  ###end USE_XML_AUDIO_POLICY_CONF
