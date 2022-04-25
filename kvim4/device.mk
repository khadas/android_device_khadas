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

ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/newdevices/manifest_common.xml
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/newdevices/manifest_ir.xml
ifeq ($(TARGET_BUILD_LIVETV),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/newdevices/manifest_tv.xml
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/khadas/common/hidl_manifests/newdevices/device_matrix_product_amlogic_tv.xml
endif
ifeq ($(PRODUCT_SUPPORT_DTVKIT),true)
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/khadas/common/hidl_manifests/newdevices/device_matrix_product_amlogic_dtvkit.xml
endif
ifeq ($(AB_OTA_UPDATER),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/newdevices/manifest_boot.xml
endif
ifeq ($(TARGET_BUILD_IRDETO),true)
DEVICE_MANIFEST_FILE += device/khadas/$(PRODUCT_DIR)/newdevices/manifest_irdeto.xml
endif
ifeq ($(BUILD_WITH_MIRACAST),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/newdevices/manifest_wfd.xml
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/khadas/common/hidl_manifests/newdevices/device_matrix_product_amlogic_wfd.xml
endif
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/khadas/common/hidl_manifests/newdevices/device_matrix_product_amlogic.xml

PRODUCT_SHIPPING_API_LEVEL := 30
else
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_common.xml
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_ir.xml
ifeq ($(TARGET_BUILD_LIVETV),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_tv.xml
endif
ifeq ($(AB_OTA_UPDATER),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_boot.xml
endif
ifeq ($(TARGET_BUILD_IRDETO),true)
DEVICE_MANIFEST_FILE += device/khadas/$(PRODUCT_DIR)/manifest_irdeto.xml
endif
ifeq ($(TARGET_BUILD_NETFLIX_MGKID),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_netflix.xml
endif
ifeq ($(BUILD_WITH_MIRACAST),true)
DEVICE_MANIFEST_FILE += device/khadas/common/hidl_manifests/manifest_wfd.xml
endif

PRODUCT_SHIPPING_API_LEVEL := 29
endif

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

PRODUCT_SOONG_NAMESPACES += \
    device/khadas/common \
    hardware/amlogic \
    vendor/amlogic/common \
    vendor/amlogic/$(PRODUCT_DIR)

PRODUCT_CHARACTERISTICS := tv,nosdcard

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/init.amlogic.board.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.board.rc

ifeq ($(TARGET_BUILD_IRDETO),true)
PRODUCT_COPY_FILES += \
    device/khadas/common/initscripts/audio.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/audio.rc
endif

#########################################################################
#
# Media codec
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/files/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/khadas/$(PRODUCT_DIR)/files/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

ifeq ($(TARGET_WITH_MEDIA_EXT), true)
PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/files/media_codecs_ext.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_ext.xml
endif

#Display config
PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/files/mesondisplay.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mesondisplay.cfg \
    device/khadas/$(PRODUCT_DIR)/files/mesondisplay.cfg:recovery/root/sbin/mesondisplay.cfg

# ddr 1g config file
PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/files/mem_mode/mem_1g_ro.prop:$(TARGET_COPY_OUT_VENDOR)/etc/mem_1g_ro.prop

# Include drawables for all densities
PRODUCT_AAPT_CONFIG := normal large xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

#########################################################################
#
# Audio
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/files/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    device/khadas/$(PRODUCT_DIR)/files/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

PRODUCT_CHARACTERISTICS := kvim4,nosdcard
ifeq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PACKAGE_OVERLAYS := \
    device/khadas/$(PRODUCT_DIR)/overlay
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
   device/khadas/$(PRODUCT_DIR)/overlay
endif

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk)


$(call inherit-product, device/khadas/common/products/tv/t7/device.mk)

#Dolby MS12 2.4 Decryption
include device/khadas/common/dolby_ms12/dolby_ms12.mk

ifeq ($(BOARD_USES_DYNAMIC_FINGERPRINT),true)
PRODUCT_OEM_PROPERTIES := ro.product.name
PRODUCT_OEM_PROPERTIES += ro.product.brand
PRODUCT_OEM_PROPERTIES += ro.product.device
PRODUCT_OEM_PROPERTIES += ro.product.manufacturer
PRODUCT_OEM_PROPERTIES += ro.product.model
endif

