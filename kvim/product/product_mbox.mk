$(call inherit-product, device/khadas/common/core_amlogic.mk)
ifeq ($(BUILD_WITH_ROOT_CONFIG),true)
$(call inherit-product, vendor/amlogic/root/root.mk)
endif


PRODUCT_PACKAGES += \
    imageserver \
    busybox \
    utility_busybox

# DLNA
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
    DLNA
endif

PRODUCT_PACKAGES += \
    remotecfg

USE_CUSTOM_AUDIO_POLICY := 1

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
# NativeImagePlayer
PRODUCT_PACKAGES += \
    NativeImagePlayer
endif

#droid vold
PRODUCT_PACKAGES += \
    droidvold

# Camera Hal
PRODUCT_PACKAGES += \
    camera.amlogic

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.display.id=VIM_Oreo_$(shell date +%Y%m%d)

#USB PM
PRODUCT_PACKAGES += \
    usbtestpm \
    usbpower

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/khadas/common/config/lowmemorykiller_2G.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_2G.txt \
	device/khadas/common/config/lowmemorykiller.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller.txt \
	device/khadas/common/config/lowmemorykiller_512M.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_512M.txt
endif

#DDR LOG
PRODUCT_COPY_FILES += \
    device/khadas/common/ddrtest.sh:$(TARGET_COPY_OUT_VENDOR)/bin/ddrtest.sh

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml

custom_keylayouts := $(wildcard device/khadas/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(notdir $(file)))

# hdcp_tx22
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/../../common/hdcp_tx22/hdcp_tx22:$(TARGET_COPY_OUT_VENDOR)/bin/hdcp_tx22

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/mbox.mp4:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo

# default wallpaper for mbox to fix bug 106225
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:$(TARGET_COPY_OUT_VENDOR)/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
$(call inherit-product, $(VERSION_ID))

DISPLAY_BUILD_NUMBER := true
