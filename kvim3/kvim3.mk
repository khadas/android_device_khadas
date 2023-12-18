# Copyright (C) 2011 Amlogic Inc
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
# This file is the build configuration for a full Android
# build for Meson reference board.
#
#ATV version, need compile DRM related modules
ifneq ($(BOARD_COMPILE_ATV),false)
  BOARD_COMPILE_CTS := true
endif

PRODUCT_DIR := kvim3

########################################################################
#
#                            TV
#
########################################################################
ifneq (,$(filter $(TARGET_PRODUCT),kvim3))
TARGET_BUILD_LIVETV := false
else
TARGET_BUILD_LIVETV := true
endif

ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_PACKAGES += \
    droidlogic.tv.software.core.xml

#dvbstack
BOARD_HAS_ADTV := true

#tuner
TUNER_MODULE := cxd2856
include device/khadas/common/tuner/tuner.mk

#dtvkit
ifneq ($(TARGET_BUILD_IRDETO),true)
PRODUCT_SUPPORT_DTVKIT := true
SUPPORT_DTVKIT_IN_VENDOR := true
endif
endif

PRODUCT_PACKAGES += \
    libdvbcallsocket \
    am_av_test



ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.support.mvc=false
endif


$(call inherit-product, device/khadas/common/products/mbox/product_mbox.mk)
$(call inherit-product, device/khadas/kvim3/device.mk)
$(call inherit-product, device/khadas/kvim3/vendor_prop.mk)
$(call inherit-product-if-exists, vendor/amlogic/kvim3/device-vendor.mk)


PRODUCT_HAS_NETFLIX_PACKAGE := true
$(call inherit-product-if-exists, vendor/amlogic/kvim3/nts/nts.mk)
#########################################################################
#
#                                               Media extension
#
#########################################################################
TARGET_WITH_MEDIA_EXT_LEVEL := 4
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 1)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT :=true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 2)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 3)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 4)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
    TARGET_WITH_PLAYERS_EXT := true
endif
endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
        ro.hdmi.device_type=4 \
        persist.sys.hdmi.keep_awake=false
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.display.id = VIM3-Android-11-32bit-V$(shell date +%y%m%d)

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.sys.cec.set_menu_language=false

#wifi hotpot
PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.softap.band=0
PRODUCT_COPY_FILES += \
	device/khadas/$(PRODUCT_DIR)/rsdb.sh:$(TARGET_COPY_OUT_VENDOR)/bin/rsdb.sh
# add softap sh
PRODUCT_COPY_FILES += \
        device/khadas/$(PRODUCT_DIR)/start_softap.sh:$(TARGET_COPY_OUT_VENDOR)/bin/start_softap.sh

# add cmdclient & cmdserver
PRODUCT_COPY_FILES += \
        device/khadas/common/cmdclient:$(TARGET_COPY_OUT_SYSTEM)/bin/cmdclient \
        device/khadas/common/cmdserver:$(TARGET_COPY_OUT_SYSTEM)/bin/cmdserver

PRODUCT_NAME := kvim3
PRODUCT_DEVICE := kvim3
PRODUCT_BRAND := Khadas
PRODUCT_MODEL := VIM3
PRODUCT_MANUFACTURER := Khadas

PRODUCT_TYPE := mbox

BOARD_AML_VENDOR_PATH := vendor/amlogic/common/
BOARD_WIDEVINE_TA_PATH := vendor/amlogic/

PROCUDT_UBOOT_PARAMS := kvim3

OTA_UP_PART_NUM_CHANGED := true

BOARD_AML_TDK_KEY_PATH := device/khadas/common/tdk_keys/
BUILD_WITH_AVB := true
BUILD_WITH_UDC := false

BOARD_USES_ODM_EXTIMAGE := true

TARGET_BUILD_KERNEL_4_9 ?= true

NEED_ISP := true

ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
AB_OTA_UPDATER :=true
endif

ifeq ($(AB_OTA_UPDATER),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
BUILDING_VENDOR_BOOT_IMAGE ?= true
endif
endif

#JUST FOR QA TEST REQUIREMENT
PRODUCT_PACKAGES += \
    Gallery2

PRODUCT_USE_DYNAMIC_PARTITIONS := true
#BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

#########################################################################
#
#                          SECURE BOOT V3
#
#########################################################################
#########Support compiling out encrypted zip/aml_upgrade_package.img directly
BOARD_AML_SECUREBOOT_KEY_DIR := ./bootloader/uboot/board/khadas/kvim3/aml-key
BOARD_AML_SECUREBOOT_SOC_TYPE := g12b

#########################################################################
#
#                          Dm-Verity
#
#########################################################################
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true

#########################################################################
#
#                      WiFi and Bluetooth
#
#########################################################################
include vendor/amlogic/common/wifi_bt/wifi/configs/wifi.mk
BOARD_HAVE_BLUETOOTH := true
include vendor/amlogic/common/wifi_bt/bluetooth/configs/bluetooth.mk

#########################################################################
#
# Audio
#
#########################################################################
BOARD_ALSA_AUDIO=tiny
include device/khadas/common/audio.mk

#########################################################################
#
#                                                GDC
#
#########################################################################
BOARD_GDC_FW_BUILTIN := true
BOARD_GDC_LIB := true

ifeq ($(BOARD_GDC_FW_BUILTIN),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/gdc,$(TARGET_COPY_OUT_VENDOR)/lib/firmware/gdc)
endif

ifeq ($(BOARD_GDC_LIB),true)
PRODUCT_PACKAGES += libgdc
endif

#########################################################################

#########################################################################
#
# PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP

#########################################################################
#
# Verimatrix DRM
#
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################

#########################################################################
#
#  WifiDisplay
#
##########################################################################
ifeq ($(BOARD_COMPILE_ATV), false)
BUILD_WITH_MIRACAST := true
endif

#########################################################################


$(call inherit-product, device/khadas/common/media.mk)

########################################################################
#
#                          Audio License Decoder
#
########################################################################
TARGET_DOLBY_MS12_VERSION := 2
ifeq ($(TARGET_DOLBY_MS12_VERSION), 2)
    TARGET_BUILD_DOLBY_MS12_V2 := true
else
    TARGET_BUILD_DOLBY_MS12_V1 := true
endif

#TARGET_BUILD_DOLBY_DDP := true
TARGET_BUILD_DTSHD := true

BOARD_USES_USB_PM := true

include device/khadas/common/software.mk
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=280

#########################################################################
#
#           OEM Partitions based dynamic fingerprint
#
#########################################################################
BOARD_USES_DYNAMIC_FINGERPRINT ?= true

#########################################################################
#
# TB detect
#
#########################################################################
$(call inherit-product, device/khadas/common/tb_detect.mk)

ifeq ($(AB_OTA_UPDATER),true)
my_src_fstab := fstab.ab
else
my_src_fstab := fstab.system
endif

ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
my_src_fstab := $(my_src_fstab)_4.9
endif

ifeq ($(BOARD_USES_DYNAMIC_FINGERPRINT),true)
my_src_fstab := $(my_src_fstab)_oem
endif

ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
my_dst_fstab := $(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.amlogic
else
my_dst_fstab := $(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.amlogic
endif

PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/$(my_src_fstab).amlogic:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.amlogic \
    device/khadas/$(PRODUCT_DIR)/$(my_src_fstab).amlogic:$(my_dst_fstab)

BOARD_INSTALL_VULKAN:=true
#include device/khadas/common/gpu/dvalin-user-arm64.mk
include device/khadas/common/gpu/gondul-user-arm64.mk

include device/khadas/common/products/mbox/g12a/g12a.mk

#########################################################################
#
#                          Khadas Build Config
#
#########################################################################
BUILD_WITH_GAPPS_CONFIG := true

#########################################################################
#
##                                     Auto Patch
#                          must put in the end of mk files
##########################################################################
#ifeq ($(BOARD_COMPILE_ATV),false)
#AUTO_PATCH_SHELL_FILE := vendor/amlogic/common/pre_submit_for_google/auto_patch.sh
#HAVE_WRITED_SHELL_FILE := $(shell test -f $(AUTO_PATCH_SHELL_FILE) && echo yes)
#IS_REFERENCE_PROJECT := true
#ifeq ($(HAVE_WRITED_SHELL_FILE),yes)
#SCRIPT_RESULT :=$(shell ($(AUTO_PATCH_SHELL_FILE) $(IS_REFERENCE_PROJECT) $(TARGET_BUILD_LIVETV)  $(BOARD_COMPILE_ATV) )))
#ifeq ($(filter Error,$(SCRIPT_RESULT)), Error)
#$(error $(SCRIPT_RESULT))
#else
#$(warning $(SCRIPT_RESULT))
#endif
#endif
#endif
