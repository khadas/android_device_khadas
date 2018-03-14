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

PRODUCT_COPY_FILES += \
    device/khadas/kvim2l/product/init.amlogic.rc:root/init.amlogic.rc \
    device/khadas/kvim2l/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
    device/khadas/kvim2l/product/ueventd.amlogic.rc:root/ueventd.amlogic.rc \
    device/khadas/kvim2l/init.amlogic.board.rc:root/init.amlogic.board.rc

PRODUCT_COPY_FILES += \
    device/khadas/kvim2l/files/media_profiles.xml:system/etc/media_profiles.xml \
    device/khadas/kvim2l/files/audio_policy.conf:system/etc/audio_policy.conf \
    device/khadas/kvim2l/files/media_codecs.xml:system/etc/media_codecs.xml \
    device/khadas/kvim2l/files/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    device/khadas/kvim2l/files/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/khadas/kvim2l/files/mesondisplay.cfg:system/etc/mesondisplay.cfg \
    device/khadas/kvim2l/files/pq.db:system/etc/pq.db \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml

# remote IME config file
PRODUCT_COPY_FILES += \
    device/khadas/kvim2l/files/remote.conf:system/etc/remote.conf \
    device/khadas/kvim2l/files/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/khadas/kvim2l/files/Generic.kl:/system/usr/keylayout/Generic.kl
PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := mbx,nosdcard

DEVICE_PACKAGE_OVERLAYS := \
    device/khadas/kvim2l/overlay

PRODUCT_TAGS += dalvik.gc.type-precise
$(shell python $(LOCAL_PATH)/auto_generator.py preinstall)
-include device/khadas/kvim2l/preinstall/preinstall.mk
PRODUCT_COPY_FILES += \
     device/khadas/kvim2l/preinstall/preinstall.sh:system/bin/preinstall.sh

PRODUCT_COPY_FILES += \
     device/khadas/kvim2l/rsdb.sh:system/bin/rsdb.sh

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp
