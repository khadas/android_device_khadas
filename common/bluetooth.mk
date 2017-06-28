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

#Support modules:
#   bcm40183, AP6210, AP6476, AP6330, AP62x2,AP6335,mt5931 & mt6622

ifeq ($(BOARD_HAVE_BLUETOOTH),false)
    BLUETOOTH_MODULE :=
endif

ifeq ($(MULTI_BLUETOOTH_SUPPORT), true)
    BOARD_HAVE_BLUETOOTH := true
    PRODUCT_PROPERTY_OVERRIDES += \
        config.disable_bluetooth=false
else
ifeq ($(BLUETOOTH_MODULE),)
    BOARD_HAVE_BLUETOOTH := false
    PRODUCT_PROPERTY_OVERRIDES += \
        config.disable_bluetooth=true
else
    BOARD_HAVE_BLUETOOTH := true
    PRODUCT_PROPERTY_OVERRIDES += \
        config.disable_bluetooth=false
endif
endif

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
PRODUCT_PACKAGES += Bluetooth \
    bt_vendor.conf \
    bt_stack.conf \
    bt_did.conf \
    auto_pair_devlist.conf \
    libbt-hci \
    bluetooth.default \
    audio.a2dp.default \
    libbt-client-api \
    com.broadcom.bt \
    com.broadcom.bt.xml

PRODUCT_COPY_FILES += \
    hardware/amlogic/libbt/data/auto_pairing.conf:system/etc/bluetooth/auto_pairing.conf \
    hardware/amlogic/libbt/data/blacklist.conf:system/etc/bluetooth/blacklist.conf

ifneq ($(wildcard device/khadas/$(TARGET_PRODUCT)/bluetooth),)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/khadas/$(TARGET_PRODUCT)/bluetooth
endif

endif

################################################################################## bcm40183
ifeq ($(BLUETOOTH_MODULE),bcm40183)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += device/khadas/common/tools/BCM40183B2_26M.hcd:system/etc/bluetooth/BCM4330.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

ifeq ($(BLUETOOTH_USE_BPLUS), true)
ifeq ($(BCM_BLUETOOTH_LPM_ENABLE), true)
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_lpm.conf:system/etc/bluetooth/bt_vendor.conf
else
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf
endif
endif
endif

################################################################################## AP6269
ifeq ($(BLUETOOTH_MODULE),AP6269)

BOARD_HAVE_BLUETOOTH_BCM := true
BCM_USB_BT := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6269/BT/bcm43569a2.hcd:system/etc/bluetooth/bcm43569a2.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif

################################################################################## AP6242
ifeq ($(BLUETOOTH_MODULE),AP6242)

BOARD_HAVE_BLUETOOTH_BCM := true
BCM_USB_BT := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6242/BT/bcm43242a1.hcd:system/etc/bluetooth/bcm43242a1.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif

################################################################################## AP6210
ifeq ($(BLUETOOTH_MODULE),AP6210)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/BT/bcm20710a1.hcd:system/etc/bluetooth/BCM20702.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

ifeq ($(BLUETOOTH_USE_BPLUS), true)
ifeq ($(BCM_BLUETOOTH_LPM_ENABLE), true)
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_AP6210_lpm.conf:system/etc/bluetooth/bt_vendor.conf
else
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_AP6210.conf:system/etc/bluetooth/bt_vendor.conf
endif
endif
endif
################################################################################## AP6476
ifeq ($(BLUETOOTH_MODULE),AP6476)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/GPS/bcm2076b1.hcd:system/etc/bluetooth/BCM2076.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

ifeq ($(BLUETOOTH_USE_BPLUS), true)
ifeq ($(BCM_BLUETOOTH_LPM_ENABLE), true)
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_AP6476_lpm.conf:system/etc/bluetooth/bt_vendor.conf
else
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_AP6476.conf:system/etc/bluetooth/bt_vendor.conf
endif
endif
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_stack.conf:system/etc/bluetooth/bt_stack.conf
endif
################################################################################## AP6330
ifeq ($(BLUETOOTH_MODULE),AP6330)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/BT/bcm40183b2.hcd:system/etc/bluetooth/BCM4330.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

ifeq ($(BLUETOOTH_USE_BPLUS), true)
ifeq ($(BCM_BLUETOOTH_LPM_ENABLE), true)
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor_lpm.conf:system/etc/bluetooth/bt_vendor.conf
else
    PRODUCT_COPY_FILES += device/khadas/common/bplus/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf
endif
endif
endif

ifeq ($(BLUETOOTH_USE_BPLUS), true)
# BPlus
PRODUCT_COPY_FILES += \
    device/khadas/common/bplus/bplus.default.so:system/lib/hw/bplus.default.so

PRODUCT_COPY_FILES += \
    device/khadas/common/bplus/iop_bt.db:system/etc/bluetooth/iop_bt.db \
    device/khadas/common/bplus/bt_did.conf:system/etc/bluetooth/bt_did.conf

PRODUCT_PACKAGES += libbt_cust \
    leexplorer
endif

################################################################################## AP62x2
ifeq ($(BLUETOOTH_MODULE),AP62x2)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/BT/bcm43241b4.hcd:system/etc/bluetooth/bcm43241b4.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif
################################################################################## AP6335
ifeq ($(BLUETOOTH_MODULE),AP6335)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/BT/bcm4335c0.hcd:system/etc/bluetooth/bcm4335c0.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif
################################################################################## AP6441
ifeq ($(BLUETOOTH_MODULE),AP6441)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6441/BT/bcm43341b0.hcd:system/etc/bluetooth/bcm43341b0.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif
################################################################################## AP6441
ifeq ($(BLUETOOTH_MODULE),AP6234)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6234/BT/bcm43341b0.hcd:system/etc/bluetooth/bcm43341b0.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif
################################################################################## AP6212
ifeq ($(BLUETOOTH_MODULE),AP6212)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/BT/bcm43438a0.hcd:system/etc/bluetooth/4343.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
endif

################################################################################## AP6354
ifeq ($(BLUETOOTH_MODULE),AP6354)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/bcm4354a1.hcd:system/etc/bluetooth/BCM4350.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif


################################################################################## AP6255
ifeq ($(BLUETOOTH_MODULE),AP6255)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/BT/BCM4345C0.hcd:system/etc/bluetooth/BCM4345C0.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif


################################################################################## bcm4356
ifeq ($(BLUETOOTH_MODULE),bcm4356)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/bcm4356a2.hcd:system/etc/bluetooth/BCM4354.hcd
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
PRODUCT_PACKAGES += libbt-vendor
endif

################################################################################## bcm4358
ifeq ($(BLUETOOTH_MODULE),bcm4358)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4358/BT/BCM4358A3.hcd:system/etc/bluetooth/BCM4358A3.hcd
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
PRODUCT_PACKAGES += libbt-vendor
endif


################################################################################## bcm43458
ifeq ($(BLUETOOTH_MODULE),bcm43458)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/43458/BCM4345C0.hcd:system/etc/bluetooth/BCM4345.hcd
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
PRODUCT_PACKAGES += libbt-vendor
endif
################################################################################## bcm43341
ifeq ($(BLUETOOTH_MODULE),bcm43341)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_usi/config/43341/BCM43341B0_002.001.014.0018.0000_USI_WM-BAN-BM-13_CL15_TESTONLY.hcd:system/etc/bluetooth/bcm43341b0.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif

################################################################################## bcm43241
ifeq ($(BLUETOOTH_MODULE),bcm43241)

BOARD_HAVE_BLUETOOTH_BCM := true

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_usi/config/43241/BCM4324B3_USI_WM-BAN-BM-10.hcd:system/etc/bluetooth/bcm4324b3.hcd

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += libbt-vendor

endif

################################################################################## mt6622
ifeq ($(BLUETOOTH_MODULE),mt6622)
BOARD_HAVE_BLUETOOTH_MTK := true
PRODUCT_PACKAGES += libbluetooth_mtk \
    MTK_MT6622_E2_Patch.nb0
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/bluetooth),)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(TARGET_PRODUCT_DIR)/bluetooth
endif
endif
################################################################################## rtl8723bs,rtl8761
#ifeq ($(BLUETOOTH_MODULE),rtl8723bs)
ifneq ($(filter rtl8761 rtl8723bs rtl8723bu rtl8821 rtl8822bu, $(BLUETOOTH_MODULE)),)

BLUETOOTH_USR_RTK_BLUEDROID := true
#Realtek add start
$(call inherit-product, hardware/realtek/bluetooth/rtkbt/rtkbt.mk )
#realtek add end
PRODUCT_PACKAGES += libbt-vendor

#Realtek add start
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
#realtek add end
endif

################################################################################## qca9377
ifeq ($(BLUETOOTH_MODULE),qca9377)
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := false


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    hardware/amlogic/wifi/qcom/config/qca9377/bt/nvm_tlv_tf_1.1.bin:system/etc/bluetooth/qca9377/ar3k/nvm_tlv_tf_1.1.bin \
    hardware/amlogic/wifi/qcom/config/qca9377/bt/rampatch_tlv_tf_1.1.tlv:system/etc/bluetooth/qca9377/ar3k/rampatch_tlv_tf_1.1.tlv

PRODUCT_PROPERTY_OVERRIDES += poweroff.doubleclick=1
PRODUCT_PROPERTY_OVERRIDES += qcom.bluetooth.soc=rome_uart
#PRODUCT_PROPERTY_OVERRIDES += bt.qcom9377.power=off

endif

################################################################################## qca6174
ifeq ($(BLUETOOTH_MODULE),qca6174)
BOARD_HAVE_BLUETOOTH_QCOM := true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    hardware/amlogic/wifi/qcom/config/qca6174/bt/nvm_tlv_3.2.bin:system/etc/bluetooth/qca6174/ar3k/nvm_tlv_3.2.bin \
    hardware/amlogic/wifi/qcom/config/qca6174/bt/rampatch_tlv_3.2.tlv:system/etc/bluetooth/qca6174/ar3k/rampatch_tlv_3.2.tlv

PRODUCT_PROPERTY_OVERRIDES += wc_transport.soc_initialized=0

PRODUCT_PACKAGES += libbt-vendor
endif

##################################################################################multi_bt
ifeq ($(MULTI_BLUETOOTH_SUPPORT), true)

BOARD_HAVE_BLUETOOTH_BCM := true
#BOARD_HAVE_BLUETOOTH_RTK := true
PRODUCT_PACKAGES += \
    libbt-vendor
#    libbt-vendor-rtl-uart \
#    libbt-vendor-rtl-usb

PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6210/BT/bcm20710a1.hcd:system/etc/bluetooth/BCM20702.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6476/GPS/bcm2076b1.hcd:system/etc/bluetooth/BCM2076.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6330/BT/bcm40183b2.hcd:system/etc/bluetooth/BCM4330.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/62x2/BT/bcm43241b4.hcd:system/etc/bluetooth/bcm43241b4.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6335/BT/bcm4335c0.hcd:system/etc/bluetooth/bcm4335c0.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6441/BT/bcm43341b0.hcd:system/etc/bluetooth/bcm43341b0.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/BT/bcm43438a0.hcd:system/etc/bluetooth/4343.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6212/BT/bcm43438a1.hcd:system/etc/bluetooth/BCM43430A1.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4354/bcm4354a1.hcd:system/etc/bluetooth/BCM4350.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/4356/bcm4356a2.hcd:system/etc/bluetooth/BCM4354.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6255/BT/BCM4345C0.hcd:system/etc/bluetooth/BCM4345C0.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/AP6269/BT/bcm43569a2.hcd:system/etc/bluetooth/bcm43569a2.hcd
PRODUCT_COPY_FILES += hardware/amlogic/wifi/bcm_ampak/config/6359sa/BT/BCM4359C0.hcd:system/etc/bluetooth/BCM4359C0.hcd

#$(call inherit-product, hardware/realtek/bluetooth/firmware/uart/rtlbtfw_cfg.mk )
#$(call inherit-product, hardware/realtek/bluetooth/firmware/usb/rtl8723b/device-rtl.mk)
#$(call inherit-product, hardware/realtek/bluetooth/firmware/usb/rtl8761a/device-rtl.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
endif
