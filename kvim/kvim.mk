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

ANDROID_BUILD_TYPE := 64

# Dynamic enable start/stop zygote_secondary in 64bits
# and 32bit system, default closed
#TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE := true

# Inherit from those products. Most specific first.
ifneq ($(ANDROID_BUILD_TYPE), 32)
ifeq ($(TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE), true)
$(call inherit-product, device/khadas/common/dynamic_zygote_seondary/dynamic_zygote_64_bit.mk)
else
$(call inherit-product, build/target/product/core_64_bit.mk)
endif
endif

$(call inherit-product, device/khadas/kvim/product/product_mbox.mk)
$(call inherit-product, device/khadas/kvim/device.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

# p212:
PRODUCT_PROPERTY_OVERRIDES += \
        ro.hdmi.device_type=4 \
        persist.sys.hdmi.keep_awake=false

PRODUCT_NAME := kvim
PRODUCT_DEVICE := kvim
PRODUCT_BRAND := Khadas
PRODUCT_MODEL := VIM
PRODUCT_MANUFACTURER := Khadas

PRODUCT_TYPE := mbox

#BOARD_OLD_PARTITION := true

WITH_LIBPLAYER_MODULE := false

OTA_UP_PART_NUM_CHANGED := true

#AB_OTA_UPDATER :=true

ifeq ($(AB_OTA_UPDATER),true)
AB_OTA_PARTITIONS := \
    boot \
    system

ifneq ($(BOARD_OLD_PARTITION),true)
AB_OTA_PARTITIONS += \
    vendor \
    odm
endif

TARGET_BOOTLOADER_CONTROL_BLOCK := true
TARGET_NO_RECOVERY := true
TARGET_PARTITION_DTSI := partition_mbox_ab.dtsi
else
TARGET_NO_RECOVERY := false

ifneq ($(BOARD_OLD_PARTITION),true)
TARGET_PARTITION_DTSI := partition_mbox_normal.dtsi
else
TARGET_PARTITION_DTSI := partition_mbox_old.dtsi
endif

BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

#########Support compiling out encrypted zip/aml_upgrade_package.img directly
#PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY := true
PRODUCT_AML_SECUREBOOT_USERKEY := ./uboot/board/khadas/kvim/aml-user-key.sig
PRODUCT_AML_SECUREBOOT_SIGNTOOL := ./uboot/fip/gxl/aml_encrypt_gxl
PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --bootsig \
						--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY) \
						--aeskey enable
PRODUCT_AML_SECUREBOOT_SIGNIMAGE := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --imgsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)
PRODUCT_AML_SECUREBOOT_SIGBIN	:= $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --binsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)

########################################################################
#
#                           ATV
#
########################################################################
ifeq ($(BOARD_COMPILE_ATV),true)
BOARD_COMPILE_CTS := true
TARGET_BUILD_GOOGLE_ATV:= true
DONT_DEXPREOPT_PREBUILTS:= true
endif
########################################################################

########################################################################
#
#                           CTS
#
########################################################################
ifeq ($(BOARD_COMPILE_CTS),true)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
BOARD_PLAYREADY_LEVEL := 1
TARGET_BUILD_CTS:= true
TARGET_BUILD_NETFLIX:= true
endif
########################################################################

#########################################################################
#
#                                                Dm-Verity
#
#########################################################################
#BUILD_WITH_DM_VERITY := true
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
BUILD_WITH_DM_VERITY := true
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_PACKAGES += \
	libfs_mgr \
	fs_mgr \
	slideshow
endif
ifneq ($(BOARD_OLD_PARTITION),true)
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
ifeq ($(AB_OTA_UPDATER),true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.AB.verity.amlogic:root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.AB.amlogic:root/fstab.amlogic
endif
else
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.verity.amlogic:root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.amlogic:root/fstab.amlogic
endif
endif
else
ifeq ($(AB_OTA_UPDATER),true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.AB.verity.amlogic:recovery/root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.AB.amlogic:recovery/root/fstab.amlogic
endif
else
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.verity.amlogic:recovery/root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.amlogic:recovery/root/fstab.amlogic
endif
endif
endif
endif
ifeq ($(BOARD_OLD_PARTITION),true)
PRODUCT_COPY_FILES += \
    device/khadas/kvim/fstab.3.14.amlogic:root/fstab.amlogic
endif

#########################################################################
#
#                                                WiFi
#
#########################################################################

MULTI_WIFI_SUPPORT := true
#WIFI_MODULE := AP6335
include device/khadas/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11


#########################################################################
#
#                                                Bluetooth
#
#########################################################################

BOARD_HAVE_BLUETOOTH := true
MULTI_BLUETOOTH_SUPPORT := true
BCM_BLUETOOTH_LPM_ENABLE := true
include device/khadas/common/bluetooth.mk


#########################################################################
#
#                                                ConsumerIr
#
#########################################################################

#PRODUCT_PACKAGES += \
#    consumerir.amlogic \
#    SmartRemote
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml


#PRODUCT_PACKAGES += libbt-vendor

ifeq ($(SUPPORT_HDMIIN),true)
PRODUCT_PACKAGES += \
    libhdmiin \
    HdmiIn
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

# Audio
#
BOARD_ALSA_AUDIO=tiny
include device/khadas/common/audio.mk

#########################################################################
#
#                                                Camera
#
#########################################################################

ifneq ($(TARGET_BUILD_CTS), true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml
endif



#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP
#########################################################################
#
#                                                Verimatrix DRM
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################


#DRM Widevine
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
TARGET_ENABLE_TA_SIGN := true
TARGET_USE_HW_KEYMASTER := true
endif

$(call inherit-product, device/khadas/common/media.mk)

#########################################################################
#
#                                                Languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US en_AU en_IN fr_FR it_IT es_ES et_EE de_DE nl_NL cs_CZ pl_PL ja_JP \
  zh_TW zh_CN zh_HK ru_RU ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG \
  ca_ES en_GB fi_FI hi_IN hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA \
  vi_VN tl_PH ar_EG fa_IR th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN en_XA ar_XB fr_CA km_KH \
  lo_LA ne_NP si_LK mn_MN hy_AM az_AZ ka_GE my_MM mr_IN ml_IN is_IS mk_MK ky_KG eu_ES gl_ES \
  bn_BD ta_IN kn_IN te_IN uz_UZ ur_PK kk_KZ

#################################################################################
#
#                                                PPPOE
#
#################################################################################
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
BUILD_WITH_PPPOE := true
endif

ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.software.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.platform.has.pppoe=true
endif

#################################################################################
#
#                                                DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Third_party_apk_camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/Third_party_apk_camera.xml \

include device/khadas/common/software.mk
ifeq ($(TARGET_BUILD_GOOGLE_ATV),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240
endif


#########################################################################
#
#                                     A/B update
#
#########################################################################
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    bootctrl.amlogic \
    bootctl

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier \
    delta_generator \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service
endif
#########################################################################
#
#                               OpenGLES Version
#
#########################################################################
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072
