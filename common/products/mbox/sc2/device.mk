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

CHIP_DIR := device/khadas/common/products/mbox/sc2

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
    device/khadas/common/products/mbox/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

#use tv remote layout for mbox if livetv is built
ifeq ($(TARGET_BUILD_LIVETV), true)
    PRODUCT_COPY_FILES += \
       device/khadas/common/products/mbox/Vendor_0001_Product_0002.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl
else
    PRODUCT_COPY_FILES += \
       device/khadas/common/products/mbox/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl
endif

PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/recovery/remotecfg:recovery/root/sbin/remotecfg \
    $(CHIP_DIR)/recovery/recovery.kl:recovery/root/sbin/recovery.kl \
    $(CHIP_DIR)/files/remote.cfg:recovery/root/sbin/remote.cfg \
    $(CHIP_DIR)/files/remote.tab1:recovery/root/sbin/remote.tab1 \
    $(CHIP_DIR)/files/remote.tab2:recovery/root/sbin/remote.tab2 \
    $(CHIP_DIR)/files/remote.tab3:recovery/root/sbin/remote.tab3 \

#########################################################################
#
# Recovery
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/common/recovery/busybox:recovery/root/sbin/busybox \
    $(CHIP_DIR)/recovery/sh:recovery/root/sbin/sh

#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/common/products/mbox/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

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


#########################################################################
#
# PQ
#
#########################################################################
ifneq ($(BOARD_USES_ODM_EXTIMAGE),true)
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/PQ/pq.db:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq_default.ini

ifeq ($(TARGET_PRODUCT),ohm_mxl258c)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(CHIP_DIR)/files/tv/tvconfig_fccpip/,/$(TARGET_COPY_OUT_ODM)/etc/tvconfig)
else
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,$(CHIP_DIR)/files/tv/tvconfig/,/$(TARGET_COPY_OUT_ODM)/etc/tvconfig)
endif
else
ifeq ($(TARGET_PRODUCT),ohm_mxl258c)
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig_fccpip/*
else
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig/*
endif
PQ_FILES := \
    $(CHIP_DIR)/files/PQ/pq.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini
endif

#thermal 2.0 config file
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

#########################################################################
#
# Amazon Prime
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/common/amazon/prime.xml:system/etc/permissions/prime.xml

#########################################################################
#
# Audio
#
#########################################################################


ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
ifeq ($(TARGET_BUILD_DOLBY_MS12_V2),true)
ifeq ($(TARGET_BUILD_DTSHD),true)
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration_ms12_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform support dolby ms12 & dtshd decoder')
else
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration_ms12.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform support dolby ms12 decoder')
endif
else
ifeq ($(TARGET_BUILD_DOLBY_DDP),true)
ifeq ($(TARGET_BUILD_DTSHD),true)
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration_ddp_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform support dolby ddp & dtshd decoder')
else
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration_ddp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform support dolby ddp decoder')
endif
else
ifeq ($(TARGET_BUILD_DTSHD),true)
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform support dtshd decoder')
else
PRODUCT_COPY_FILES += \
    device/khadas/common/audio/$(PRODUCT_TYPE)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'This platform nonsupport dolby ms12 & dtshd decoder')
endif
endif
endif
endif
