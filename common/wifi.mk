#
# Copyright (C) 2012 The Android Open Source Project
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

#Supported modules:
#                bcm40183
#                bcm40181
#		 bcm43458
#                rtl8188eu
#                rt5370
#                rt8189es
#                rt8723bs
#                rtl8723au
#                mt7601
#                mt5931
#                AP62x2
#                AP6335
#                AP6441
#                AP6234
#                AP6181
#                AP6210
#                bcm43341
#                bcm43241
#                rtl8192du
#                rtl8192eu
#                rtl8192es
#                rtl8192cu
#                rtl88x1au
#                rtl8812au


PRODUCT_PACKAGES += wpa_supplicant.conf

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

PRODUCT_PROPERTY_OVERRIDES += \
	ro.carrier=wifi-only

################################################################################## bcm4354
ifeq ($(WIFI_MODULE),bcm4354)
WIFI_DRIVER := bcm4354
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/4354/fw_bcm4354a1_ag.bin nvram_path=/etc/wifi/4354/nvram_ap6354.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/4354/fw_bcm4354a1_ag.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/4354/fw_bcm4354a1_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/4354/fw_bcm4354a1_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
	4354/nvram_ap6354.txt \
	4354/fw_bcm4354a1_ag.bin \
	4354/fw_bcm4354a1_ag_apsta.bin \
	4354/fw_bcm4354a1_ag_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif



################################################################################## bcm4356
ifeq ($(WIFI_MODULE),bcm4356)
WIFI_DRIVER := bcm4356
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/4356/fw_bcm4356a2_ag.bin nvram_path=/etc/wifi/4356/nvram_ap6356.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/4356/fw_bcm4356a2_ag.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/4356/fw_bcm4356a2_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/4356/fw_bcm4356a2_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
        4356/nvram_ap6356.txt \
        4356/fw_bcm4356a2_ag.bin \
	4356/fw_bcm4356a2_ag_apsta.bin \
	4356/fw_bcm4356a2_ag_p2p.bin \
        wl \
        p2p_supplicant_overlay.conf \
        dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0

endif


################################################################################## bcm4358
ifeq ($(WIFI_MODULE),bcm4358)
WIFI_DRIVER := bcm4358
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/4358/fw_bcm4358_ag.bin nvram_path=/etc/wifi/4358/nvram_4358.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/4358/fw_bcm4358_ag.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/4358/fw_bcm4358_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/4358/fw_bcm4358_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
        4358/nvram_4358.txt \
        4358/fw_bcm4358_ag.bin \
    4358/fw_bcm4358_ag_apsta.bin \
    4358/fw_bcm4358_ag_p2p.bin \
        wl \
        p2p_supplicant_overlay.conf \
        dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif
PRODUCT_COPY_FILES += device/amlogic/p200/wifi/config.txt:system/etc/wifi/4358/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/config.txt:system/etc/wifi/4358/config.txt

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0

endif


################################################################################## bcm43458
ifeq ($(WIFI_MODULE),bcm43458)
WIFI_DRIVER := bcm43458
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/43458/fw_bcm43455c0_ag.bin nvram_path=/etc/wifi/43458/nvram_43458.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/43458/fw_bcm43455c0_ag.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/43458/fw_bcm43455c0_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/43458/fw_bcm43455c0_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
        43458/nvram_43458.txt \
        43458/fw_bcm43455c0_ag.bin \
	 43458/fw_bcm43455c0_ag_apsta.bin \
	 43458/fw_bcm43455c0_ag_p2p.bin \
        wl \
	p2p_supplicant_overlay.conf \
        dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0

endif


################################################################################## AP6269
ifeq ($(WIFI_MODULE),AP6269)
WIFI_DRIVER := AP6269
WIFI_DRIVER_MODULE_PATH := /system/lib/bcmdhd.ko
WIFI_DRIVER_MODULE_NAME := bcmdhd
WIFI_DRIVER_MODULE_ARG  := ""
WIFI_DRIVER_FW_PATH_STA := /system/etc/firmware/fw_bcmdhd.bin.trx
WIFI_DRIVER_FW_PATH_P2P := /system/etc/firmware/fw_bcmdhd_p2p.bin.trx
WIFI_DRIVER_FW_PATH_AP := /system/etc/firmware/fw_bcmdhd_apsta.bin.trx
BCM_USB_WIFI := true

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd


PRODUCT_PACKAGES += \
	AP6269/fw_bcm43569a2_ag.bin.trx \
	AP6269/nvram_ap6269a2.nvm \
	wl \
	p2p_supplicant_overlay.conf \
	dhd \
	bcmdl



PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
endif


################################################################################## AP6242
ifeq ($(WIFI_MODULE),AP6242)
WIFI_DRIVER := AP6242
WIFI_DRIVER_MODULE_PATH := /system/lib/bcmdhd.ko
WIFI_DRIVER_MODULE_NAME := bcmdhd
WIFI_DRIVER_MODULE_ARG  := ""
WIFI_DRIVER_FW_PATH_STA := /system/etc/firmware/fw_bcmdhd.bin.trx
WIFI_DRIVER_FW_PATH_P2P := /system/etc/firmware/fw_bcmdhd_p2p.bin.trx
WIFI_DRIVER_FW_PATH_AP := /system/etc/firmware/fw_bcmdhd_apsta.bin.trx
BCM_USB_WIFI := true

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd


PRODUCT_PACKAGES += \
	AP6242/fw_bcm43242a1_ag.bin.trx \
	AP6242/nvram_ap6242.nvm \
	wl \
	p2p_supplicant_overlay.conf \
	dhd \
	bcmdl



PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
endif

################################################################################## bcm40183
ifeq ($(WIFI_MODULE),bcm40183)

WIFI_DRIVER := bcm40183
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/40183/fw_bcm40183b2.bin nvram_path=/etc/wifi/40183/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/40183/fw_bcm40183b2.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/40183/fw_bcm40183b2_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/40183/fw_bcm40183b2_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak

PRODUCT_PACKAGES += \
	40183/nvram.txt \
	40183/fw_bcm40183b2.bin \
	40183/fw_bcm40183b2_apsta.bin \
	40183/fw_bcm40183b2_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif

################################################################################## bcm40181
ifeq ($(WIFI_MODULE),bcm40181)
WIFI_DRIVER := bcm40181
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/40181/fw_bcm40181a2.bin nvram_path=/etc/wifi/40181/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/40181/fw_bcm40181a2.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/40181/fw_bcm40181a2_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/40181/fw_bcm40181a2_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak

PRODUCT_PACKAGES += \
	40181/nvram.txt \
	40181/fw_bcm40181a0.bin \
	40181/fw_bcm40181a0_apsta.bin \
	40181/fw_bcm40181a2.bin \
	40181/fw_bcm40181a2_apsta.bin \
	40181/fw_bcm40181a2_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif
################################################################################## AP62x2
ifeq ($(WIFI_MODULE),AP62x2)
WIFI_DRIVER := AP62x2
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/62x2/fw_bcm43241b4_ag.bin nvram_path=/etc/wifi/62x2/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/62x2/fw_bcm43241b4_ag.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/62x2/fw_bcm43241b4_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/62x2/fw_bcm43241b4_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak

PRODUCT_PACKAGES += \
	62x2/nvram.txt \
	62x2/fw_bcm43241b4_ag.bin \
	62x2/fw_bcm43241b4_ag_apsta.bin \
	62x2/fw_bcm43241b4_ag_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif
################################################################################## AP6335
ifeq ($(WIFI_MODULE),AP6335)
WIFI_DRIVER := AP6335
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/6335/fw_bcm4339a0_ag.bin nvram_path=/etc/wifi/6335/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/6335/fw_bcm4339a0_ag.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/6335/fw_bcm4339a0_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/6335/fw_bcm4339a0_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak
PRODUCT_PACKAGES += \
	6335/nvram.txt \
	6335/fw_bcm4339a0_ag.bin \
	6335/fw_bcm4339a0_ag_apsta.bin \
	6335/fw_bcm4339a0_ag_p2p.bin \
	6335/nvram_ap6335e.txt   \
	6335/fw_bcm4339a0e_ag.bin \
	6335/fw_bcm4339a0e_ag_apsta.bin \
	6335/fw_bcm4339a0e_ag_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif
################################################################################## AP6441
ifeq ($(WIFI_MODULE),AP6441)
WIFI_DRIVER := AP6441
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/6441/fw_bcm43341b0_ag.bin nvram_path=/etc/wifi/6441/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/6441/fw_bcm43341b0_ag.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/6441/fw_bcm43341b0_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/6441/fw_bcm43341b0_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak
PRODUCT_PACKAGES += \
	6441/nvram.txt    \
	6441/fw_bcm43341b0_ag.bin \
	6441/fw_bcm43341b0_ag_apsta.bin \
	6441/fw_bcm43341b0_ag_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif

################################################################################## AP6234
ifeq ($(WIFI_MODULE),AP6234)
WIFI_DRIVER := AP6234
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/6234/fw_bcm43341b0_ag.bin nvram_path=/etc/wifi/6234/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/6234/fw_bcm43341b0_ag.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/6234/fw_bcm43341b0_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/6234/fw_bcm43341b0_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak
PRODUCT_PACKAGES += \
	6234/nvram.txt    \
	6234/fw_bcm43341b0_ag.bin \
	6234/fw_bcm43341b0_ag_apsta.bin \
	6234/fw_bcm43341b0_ag_p2p.bin \
	p2p_supplicant_overlay.conf \
	wl \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
endif

################################################################################## AP6212
ifeq ($(WIFI_MODULE),AP6212)
WIFI_DRIVER := AP6212
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/6212/fw_bcm43438a0.bin nvram_path=/etc/wifi/6212/nvram.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/6212/fw_bcm43438a0.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/6212/fw_bcm43438a0_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/6212/fw_bcm43438a0_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak
PRODUCT_PACKAGES += \
	6212/nvram.txt    \
	6212/fw_bcm43438a0.bin \
	6212/fw_bcm43438a0_apsta.bin \
	6212/fw_bcm43438a0_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
endif

################################################################################## AP6255
ifeq ($(WIFI_MODULE),AP6255)
WIFI_DRIVER := AP6255
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/6255/fw_bcm43455c0_ag.bin nvram_path=/etc/wifi/6255/nvram.txt"
WIFI_DRIVER_FW_PATH_STA := /etc/wifi/6255/fw_bcm43455c0_ag.bin
WIFI_DRIVER_FW_PATH_AP  := /etc/wifi/6255/fw_bcm43455c0_ag_apsta.bin
WIFI_DRIVER_FW_PATH_P2P := /etc/wifi/6255/fw_bcm43455c0_ag_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_ampak
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_ampak
PRODUCT_PACKAGES += \
	6255/nvram.txt    \
	6255/fw_bcm43455c0_ag.bin \
	6255/fw_bcm43455c0_ag_apsta.bin \
	6255/fw_bcm43455c0_ag_p2p.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
endif


################################################################################## bcm43341
ifeq ($(WIFI_MODULE),bcm43341)
WIFI_DRIVER := bcm43341
WIFI_DRIVER_MODULE_PATH := /system/lib/bcmdhd.ko
WIFI_DRIVER_MODULE_NAME := bcmdhd
WIFI_DRIVER_MODULE_ARG  := "iface_name=wlan0 firmware_path=/etc/wifi/fw_bcmdhd_43341.bin nvram_path=/etc/wifi/nvram_43341.bin"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/fw_bcmdhd_43341.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/fw_bcmdhd_43341.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/fw_bcmdhd_43341.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_usi
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_usi
PRODUCT_PACKAGES += \
	nvram_43341.bin   \
	fw_bcmdhd_43341.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/bcmdhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/bcmdhd.ko:system/lib/bcmdhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif
################################################################################## bcm43241
ifeq ($(WIFI_MODULE),bcm43241)
WIFI_DRIVER := bcm43241
WIFI_DRIVER_MODULE_PATH := /system/lib/bcmdhd.ko
WIFI_DRIVER_MODULE_NAME := bcmdhd
WIFI_DRIVER_MODULE_ARG  := "iface_name=wlan0 firmware_path=/etc/wifi/fw_bcmdhd_43241.bin nvram_path=/etc/wifi/nvram_43241.bin"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/fw_bcmdhd_43241.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/fw_bcmdhd_43241.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/fw_bcmdhd_43241.bin

BOARD_WLAN_DEVICE := bcmdhd
LIB_WIFI_HAL := libwifi-hal-bcm
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd_usi
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd_usi
PRODUCT_PACKAGES += \
	nvram_43241.bin   \
	fw_bcmdhd_43241.bin \
	wl \
	p2p_supplicant_overlay.conf \
	dhd

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:root/init.amlogic.wifi.rc
else
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi_bcm.rc:recovery/root/init.amlogic.wifi.rc
endif

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/bcmdhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/bcmdhd.ko:system/lib/bcmdhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif

################################################################################## AP6xxx
ifeq ($(WIFI_AP6xxx_MODULE),AP6181)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6181/Wi-Fi/nvram_ap6181.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6210)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/Wi-Fi/nvram_ap6210.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6476)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/Wi-Fi/nvram_ap6476.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6493)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6493/Wi-Fi/fw_bcm40183b2.bin:system/etc/wifi/40183/fw_bcm40183b2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6493/Wi-Fi/fw_bcm40183b2_apsta.bin:system/etc/wifi/40183/fw_bcm40183b2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6493/Wi-Fi/fw_bcm40183b2_p2p.bin:system/etc/wifi/40183/fw_bcm40183b2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6493/Wi-Fi/nvram_ap6493.txt:system/etc/wifi/40183/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6330)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/Wi-Fi/fw_bcm40183b2.bin:system/etc/wifi/40183/fw_bcm40183b2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/Wi-Fi/fw_bcm40183b2_apsta.bin:system/etc/wifi/40183/fw_bcm40183b2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/Wi-Fi/fw_bcm40183b2_p2p.bin:system/etc/wifi/40183/fw_bcm40183b2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/Wi-Fi/nvram_ap6330.txt:system/etc/wifi/40183/nvram.txt

endif
ifeq ($(MULTI_WIFI_SUPPORT), true)

WIFI_DRIVER_MODULE_PATH := /system/lib/
WIFI_DRIVER_MODULE_NAME := dhd

WPA_SUPPLICANT_VERSION			:= VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER	:= NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_multi
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_multi
BOARD_HOSTAPD_DRIVER				:= NL80211

WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0

PRODUCT_PACKAGES += \
    bcmdl \
	wpa_cli

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a0.bin:system/etc/wifi/6212/fw_bcm43438a0.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a0_apsta.bin:system/etc/wifi/6212/fw_bcm43438a0_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a0_p2p.bin:system/etc/wifi/6212/fw_bcm43438a0_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/nvram.txt:system/etc/wifi/6212/nvram.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/config.txt:system/etc/wifi/6212/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/nvram_ap6212.txt:system/etc/wifi/6212/nvram_ap6212.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a1.bin:system/etc/wifi/6212/fw_bcm43438a1.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a1_apsta.bin:system/etc/wifi/6212/fw_bcm43438a1_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/fw_bcm43438a1_p2p.bin:system/etc/wifi/6212/fw_bcm43438a1_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/nvram_ap6212a.txt:system/etc/wifi/6212/nvram_ap6212a.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/fw_bcm43241b4_ag.bin:system/etc/wifi/62x2/fw_bcm43241b4_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/fw_bcm43241b4_ag_apsta.bin:system/etc/wifi/62x2/fw_bcm43241b4_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/fw_bcm43241b4_ag_p2p.bin:system/etc/wifi/62x2/fw_bcm43241b4_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/nvram.txt:system/etc/wifi/62x2/nvram.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/config.txt:system/etc/wifi/62x2/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag.bin:system/etc/wifi/6255/fw_bcm43455c0_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag_apsta.bin:system/etc/wifi/6255/fw_bcm43455c0_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag_p2p.bin:system/etc/wifi/6255/fw_bcm43455c0_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/nvram.txt:system/etc/wifi/6255/nvram.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/config.txt:system/etc/wifi/6255/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag.bin:system/etc/wifi/6335/fw_bcm4339a0_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag_apsta.bin:system/etc/wifi/6335/fw_bcm4339a0_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag_p2p.bin:system/etc/wifi/6335/fw_bcm4339a0_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/nvram.txt:system/etc/wifi/6335/nvram.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/config.txt:system/etc/wifi/6335/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag.bin:system/etc/wifi/4356/fw_bcm4356a2_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag_apsta.bin:system/etc/wifi/4356/fw_bcm4356a2_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag_p2p.bin:system/etc/wifi/4356/fw_bcm4356a2_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/nvram_ap6356.txt:system/etc/wifi/4356/nvram_ap6356.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/config.txt:system/etc/wifi/4356/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag.bin:system/etc/wifi/4354/fw_bcm4354a1_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag_apsta.bin:system/etc/wifi/4354/fw_bcm4354a1_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag_p2p.bin:system/etc/wifi/4354/fw_bcm4354a1_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/nvram_ap6354.txt:system/etc/wifi/4354/nvram_ap6354.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/config.txt:system/etc/wifi/4354/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag.bin:system/etc/wifi/43458/fw_bcm43455c0_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag_apsta.bin:system/etc/wifi/43458/fw_bcm43455c0_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag_p2p.bin:system/etc/wifi/43458/fw_bcm43455c0_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/nvram_43458.txt:system/etc/wifi/43458/nvram_43458.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/config.txt:system/etc/wifi/43458/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/fw_bcm4358_ag.bin:system/etc/wifi/4358/fw_bcm4358_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/fw_bcm4358_ag_apsta.bin:system/etc/wifi/4358/fw_bcm4358_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/fw_bcm4358_ag_p2p.bin:system/etc/wifi/4358/fw_bcm4358_ag_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/nvram_4358.txt:system/etc/wifi/4358/nvram_4358.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/config.txt:system/etc/wifi/4358/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6359sa/fw_bcm4359c0_ag.bin:system/etc/wifi/6359sa/fw_bcm4359c0_ag.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6359sa/fw_bcm4359c0_ag_apsta.bin:system/etc/wifi/6359sa/fw_bcm4359c0_ag_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6359sa/nvram_ap6359sa.txt:system/etc/wifi/6359sa/nvram_ap6359sa.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6359sa/config.txt:system/etc/wifi/6359sa/config.txt
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6269/fw_bcm43569a2_ag.bin.trx:system/etc/wifi/43569/fw_bcm43569a2_ag.bin.trx
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6269/nvram_ap6269a2.nvm:system/etc/wifi/43569/nvram_ap6269a2.nvm
PRODUCT_COPY_FILES += device/khadas/common/init.amlogic.wifi.rc:root/init.amlogic.wifi.rc
PRODUCT_COPY_FILES += hardware/amlogic/wifi/multi_wifi/config/bcm_supplicant.conf:system/etc/wifi/bcm_supplicant.conf
PRODUCT_COPY_FILES += hardware/amlogic/wifi/multi_wifi/config/bcm_supplicant_overlay.conf:system/etc/wifi/bcm_supplicant_overlay.conf
PRODUCT_COPY_FILES += hardware/amlogic/wifi/multi_wifi/config/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf
PRODUCT_COPY_FILES += hardware/amlogic/wifi/multi_wifi/config/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf
PRODUCT_COPY_FILES += hardware/amlogic/wifi/multi_wifi/config/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf
PRODUCT_COPY_FILES += hardware/amlogic/wifi/mediatek/iwpriv:system/bin/iwpriv
PRODUCT_COPY_FILES += hardware/amlogic/wifi/mediatek/RT2870STA_7601.dat:system/etc/wifi/RT2870STA_7601.dat
PRODUCT_COPY_FILES += hardware/amlogic/wifi/mediatek/RT2870STA_7601.dat:system/etc/wifi/RT2870STA_7603.dat
PRODUCT_COPY_FILES += hardware/amlogic/wifi/mediatek/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf
PRODUCT_COPY_FILES += \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/bdwlan30.bin:system/etc/wifi/firmware/bdwlan30.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/otp30.bin:system/etc/wifi/firmware/otp30.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/qwlan30.bin:system/etc/wifi/firmware/qwlan30.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/utf30.bin:system/etc/wifi/firmware/utf30.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/wlan/cfg.dat:system/etc/wifi/firmware/wlan/cfg.dat \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/wlan/qcom_cfg.ini:system/etc/wifi/firmware/wlan/qcom_cfg.ini \
    hardware/amlogic/wifi/qcom/config/qca9377/wifi/wlan/qcom_wlan_nv.bin:system/etc/wifi/firmware/wlan/qcom_wlan_nv.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/bdwlan30.bin:system/etc/wifi/qca6174/bdwlan30.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/athwlan.bin:system/etc/wifi/qca6174/athwlan.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/otp30.bin:system/etc/wifi/qca6174/otp30.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/utf30.bin:system/etc/wifi/qca6174/utf30.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/qwlan30.bin:system/etc/wifi/qca6174/qwlan30.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/wlan/cfg.dat:system/etc/wifi/qca6174/wlan/cfg.dat \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/wlan/qcom_cfg.ini:system/etc/wifi/qca6174/wlan/qcom_cfg.ini \
    hardware/amlogic/wifi/qcom/config/qca6174/wifi/wlan/qcom_cfg.ini:system/etc/wifi/qca6174/wlan/qcom_cfg.ini.ok
endif
