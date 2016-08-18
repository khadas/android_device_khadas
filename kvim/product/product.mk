$(call inherit-product, device/khadas/common/core_amlogic.mk)
ifeq ($(BUILD_WITH_GAPPS_CONFIG),true)
$(call inherit-product, vendor/amlogic/google/gapps.mk)
endif

PRODUCT_PACKAGES += \
    imageserver \
    busybox \
    utility_busybox

# DLNA
PRODUCT_PACKAGES += \
    DLNA

PRODUCT_PACKAGES += \
    remotecfg

USE_CUSTOM_AUDIO_POLICY := 1

# NativeImagePlayer
PRODUCT_PACKAGES += \
    NativeImagePlayer

#RemoteControl Service
PRODUCT_PACKAGES += \
    RC_Service

# Camera Hal
PRODUCT_PACKAGES += \
    camera.amlogic

# HDMITX CEC HAL
PRODUCT_PACKAGES += \
    hdmi_cec.amlogic

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4

#Tvsettings
PRODUCT_PACKAGES += \
    Settings

#MboxLauncher
PRODUCT_PACKAGES += \
    Launcher3

#USB PM
PRODUCT_PACKAGES += \
    usbtestpm \
    usbpower

ifeq ($(BUILD_WITH_TIMER_POWER_CONFIG),true)
PRODUCT_PROPERTY_OVERRIDES += persist.has.timer.power=true

PRODUCT_PACKAGES += \
	SchPwrOnOff
else
PRODUCT_PROPERTY_OVERRIDES += persist.has.timer.power=false
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:system/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/khadas/common/config/lowmemorykiller_2G.txt:system/etc/lowmemorykiller_2G.txt \
	device/khadas/common/config/lowmemorykiller.txt:system/etc/lowmemorykiller.txt \
	device/khadas/common/config/lowmemorykiller_512M.txt:system/etc/lowmemorykiller_512M.txt
endif

#DDR LOG
PRODUCT_COPY_FILES += \
	device/khadas/common/ddrtest.sh:system/bin/ddrtest.sh

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

custom_keylayouts := $(wildcard device/khadas/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):system/usr/keylayout/$(notdir $(file)))

# hdcp_tx22
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/../../common/hdcp_tx22/hdcp_tx22:system/bin/hdcp_tx22

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/boot.mp4:system/etc/bootvideo

# default wallpaper
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:system/etc/default_wallpaper.png

ADDITIONAL_BUILD_PROPERTIES += \
    ro.config.wallpaper=/system/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
$(call inherit-product, $(VERSION_ID))

DISPLAY_BUILD_NUMBER := true
