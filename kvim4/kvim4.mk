# Copyright (C) 2018 Amlogic Inc
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
BOARD_COMPILE_ATV := false
BOARD_COMPILE_CTS := false

BUILD_WITH_GAPPS_CONFIG=false

$(call inherit-product, device/google/atv/products/atv_mainline_system.mk)

# GTVS
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/etc/permissions/privapp-permissions-google.xml \
    system/etc/permissions/privapp-permissions-atv.xml \
    system/priv-app/GooglePackageInstaller/GooglePackageInstaller.apk \
    system/usr/idc/virtual-remote.idc \
    system/usr/keylayout/virtual-remote.kl \
    system/usr/keychars/virtual-remote.kcm

# Mainline modules
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.android.apex.cts.shim.apex \
    system/apex/com.android.extservices.gms.apex \
    system/apex/com.android.extservices.gms/% \
    system/apex/com.android.permission.gms.apex \
    system/apex/com.android.permission.gms/% \
    system/apex/com.android.tethering.inprocess/% \
    system/app/PlatformCaptivePortalLogin/PlatformCaptivePortalLogin.apk \
    system/etc/permissions/GoogleExtServices_permissions.xml \
    system/etc/permissions/GooglePermissionController_permissions.xml \
    system/priv-app/InProcessNetworkStack/InProcessNetworkStack.apk \
    system/priv-app/PlatformNetworkPermissionConfig/PlatformNetworkPermissionConfig.apk

# dexopt files are side-effects of already allowed files
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += %.odex %.vdex %.art

PRODUCT_DIR := kvim4

#multiEncoder
PRODUCT_PACKAGES += \
    libamvenc_api \
    libvpcodec \
    libjpegenc_api

NEED_ISP := true

PRODUCT_SUPPORT_4K_UI := true

ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
else
ifeq ($(PRODUCT_SUPPORT_4K_UI), true)
#config of 2160UI surfaceflinger
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=480
else
#config of 1080UI surfaceflinger
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240
endif
endif

# config of surfaceflinger
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.sf.disable_triple_buffer=0

########################################################################
#
#                            TV
#
########################################################################
TARGET_BUILD_LIVETV := true
ifeq ($(TARGET_PRODUCT),ac212)
TARGET_BUILD_LIVETV := false
endif
#TARGET_BUILD_IRDETO := true
ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_PACKAGES += \
    droidlogic.tv.software.core.xml

#dvbstack
BOARD_HAS_ADTV := true

#tuner
TUNER_MODULE := cxd2856
include device/khadas/common/tuner/tuner.mk

#hdr10_tmo
HDR10_TMO_MODULE := true
include device/khadas/common/video_algorithm/hdr10_tmo/hdr10_tmo.mk

#dtvkit
ifneq ($(TARGET_BUILD_IRDETO),true)
#PRODUCT_SUPPORT_DTVKIT := true
#SUPPORT_DTVKIT_IN_VENDOR := true
endif
endif

#dnlp
DNLP_MODULE := true
include device/khadas/common/video_algorithm/dnlp/dnlp.mk

#ldim_fw
LDIM_FW_MODULE := true
include device/khadas/common/ldim/ldim.mk

#speech
SPEECH_MODULE := true
include device/khadas/common/speech/speech.mk

BOARD_ENABLE_FAR_FIELD_AEC := true

$(call inherit-product, device/khadas/common/products/tv/product_tv.mk)
$(call inherit-product, device/khadas/$(PRODUCT_DIR)/device.mk)
$(call inherit-product, device/khadas/$(PRODUCT_DIR)/vendor_prop.mk)
$(call inherit-product-if-exists, vendor/amlogic/$(PRODUCT_DIR)/device-vendor.mk)

#########################################################################
#
#                                                CTC
#
#########################################################################
BUILD_WITH_CTC_MEDIAPROCESSOR := true

#########################################################################
#
#  Amlogic Media Platform API
#
#########################################################################
BUILD_WITH_AML_MP := true

#########################################################################
#
#  Media extension
#
#########################################################################
TARGET_WITH_MEDIA_EXT_LEVEL := 4

PRODUCT_PROPERTY_OVERRIDES += \
        ro.hdmi.device_type=0

PRODUCT_NAME := kvim4
PRODUCT_DEVICE := kvim4
PRODUCT_BRAND := Amlogic
PRODUCT_MODEL := kvim4
PRODUCT_MANUFACTURER := Amlogic

PRODUCT_PROPERTY_OVERRIDES += \
        ro.build.display.id=VIM4_R_V$(shell date +%y%m%d)

PRODUCT_TYPE := tv
# Non updatable APEX
OVERRIDE_TARGET_FLATTEN_APEX := true
PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable=false

WITH_LIBPLAYER_MODULE := false

BOARD_AML_VENDOR_PATH := vendor/amlogic/common/
BOARD_WIDEVINE_TA_PATH := vendor/amlogic/

OTA_UP_PART_NUM_CHANGED := false

PLATFORM_TDK_VERSION := 38
BOARD_AML_SOC_TYPE ?= A311D2
BOARD_AML_TDK_KEY_PATH := device/khadas/common/tdk_keys/
BUILD_WITH_AVB := true
PRODUCT_PACKAGES += lights

#KVIM4 app
PRODUCT_PACKAGES += \
    Launcher3QuickStep \
    FactoryTest \
    Settings \
    KSettings \
    KTools \
    SchPwrOnOff \
    AptoideTV \
    DocumentsUI

ifeq ($(BUILD_WITH_GAPPS_CONFIG),true)

else
PRODUCT_PACKAGES += TTS
PRODUCT_COPY_FILES += \
	device/khadas/kvim4/TTS_so/libtts_android.so:system/lib64/libtts_android.so \
	device/khadas/kvim4/TTS_so/libtts_android_neon.so:system/lib64/libtts_android_neon.so
endif

TARGET_BUILD_KERNEL_4_9 ?= false

ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
AB_OTA_UPDATER :=true
BOARD_USES_ODM_EXTIMAGE := true
endif

ifeq ($(AB_OTA_UPDATER),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
BUILDING_VENDOR_BOOT_IMAGE ?= true
endif
endif

PRODUCT_USE_DYNAMIC_PARTITIONS := true

#########Support compiling out encrypted zip/aml_upgrade_package.img directly
#PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY := true
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
PRODUCT_AML_SECUREBOOT_USERKEY := ./bootloader/uboot/amlogic/t7_pxp_v1/aml-user-key.sig
PRODUCT_AML_SECUREBOOT_SIGNTOOL := ./bootloader/uboot/fip/t7/aml_encrypt_t7
PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --bootsig \
						--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY) \
						--aeskey enable
PRODUCT_AML_SECUREBOOT_SIGNIMAGE := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --imgsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)
PRODUCT_AML_SECUREBOOT_SIGBIN	:= $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --binsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)
endif #ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

#########Support compiling out encrypted zip/aml_upgrade_package.img directly with Aml_Linux_SecureBootV3_SignTool
BOARD_AML_SECUREBOOT_KEY_DIR := ./bootloader/uboot/board/amlogic/t7_pxp_v1/aml-key
BOARD_AML_SECUREBOOT_SOC_TYPE := t7

#################################################################
#
#                                                Dm-Verity
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
BOARD_HAVE_HARDWARE_EQDRC_AUGE := true
include device/khadas/common/audio.mk

#########################################################################
#
#  PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP

#########################################################################
#
#  Verimatrix DRM
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

########################################################################
#
##                          Audio License Decoder
#
#########################################################################
TARGET_DOLBY_MS12_VERSION := 2
ifeq ($(TARGET_DOLBY_MS12_VERSION), 2)
    TARGET_BUILD_DOLBY_MS12_V2 := true
else
    #TARGET_BUILD_DOLBY_MS12 := true
endif

#TARGET_BUILD_DOLBY_DDP := true
TARGET_BUILD_DTSHD := true

#################################################################################
#
#  DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true

#########################################################################
#
#           OEM Partitions based dynamic fingerprint
#
#########################################################################
BOARD_USES_DYNAMIC_FINGERPRINT ?= true

#########################################################################
#
#                                     TB detect
#
#########################################################################
$(call inherit-product, device/khadas/common/tb_detect.mk)

ifeq ($(AB_OTA_UPDATER),true)
my_src_fstab := fstab.ab
else
my_src_fstab := fstab.system
endif

ifeq ($(BOARD_USES_DYNAMIC_FINGERPRINT),true)
my_src_fstab := $(my_src_fstab)_oem
endif

my_dst_fstab := $(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.amlogic

PRODUCT_COPY_FILES += \
    device/khadas/$(PRODUCT_DIR)/$(my_src_fstab).amlogic:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.amlogic \
    device/khadas/$(PRODUCT_DIR)/$(my_src_fstab).amlogic:$(my_dst_fstab)


$(call inherit-product, device/khadas/common/media.mk)

GPU_HW_VERSION=r1p0
include device/khadas/common/gpu/gondul-user-arm64.mk

include device/khadas/common/products/tv/t7/t7.mk
#########################################################################
#
##                                     Auto Patch
#                          must put in the end of mk files
##########################################################################
AUTO_PATCH_SHELL_FILE := vendor/amlogic/common/pre_submit_for_google/auto_patch.sh
HAVE_WRITED_SHELL_FILE := $(shell test -f $(AUTO_PATCH_SHELL_FILE) && echo yes)
IS_REFERENCE_PROJECT := false

ifeq ($(IS_REFERENCE_PROJECT), true)
REFERENCE_PARAMS := true
else
REFERENCE_PARAMS := false
endif

ifneq ($(BOARD_COMPILE_ATV), false)
ATV_PARAMS := true
else
ATV_PARAMS := false
endif

ifeq ($(TARGET_BUILD_LIVETV), true)
LIVETV_PARAMS := true
else
LIVETV_PARAMS := false
endif

ifeq ($(HAVE_WRITED_SHELL_FILE),yes)
SCRIPT_RESULT :=$(shell ($(AUTO_PATCH_SHELL_FILE) $(REFERENCE_PARAMS) $(LIVETV_PARAMS)  $(ATV_PARAMS) ))
ifeq ($(filter Error,$(SCRIPT_RESULT)), Error)
$(error $(SCRIPT_RESULT))
else
$(warning $(SCRIPT_RESULT))
endif
endif

# add EM06 4G
PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=9
PRODUCT_PACKAGES += \
    rild \
    dhcptool \
    TeleService \
    TelephonyProvider

PRODUCT_COPY_FILES += \
    device/khadas/kvim4/ril/libquectel-ril/chat:system/bin/chat \
    device/khadas/kvim4/ril/libquectel-ril/libquectel-ril.so:vendor/lib/libquectel-ril.so \
    device/khadas/kvim4/ril/libquectel-ril/ip-up:system/etc/ppp/ip-up \
    device/khadas/kvim4/ril/libquectel-ril/ip-down:system/etc/ppp/ip-down \
    device/khadas/kvim4/ril/apns-conf.xml:system/etc/apns-conf.xml
#add end
