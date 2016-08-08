ifeq ($(BOARD_SUPPORT_INSTABOOT), true)

PRODUCT_PROPERTY_OVERRIDES += \
    config.disable_instaboot=false

instaboot_config_file := $(wildcard $(LOCAL_PATH)/instaboot_config.xml)

PRODUCT_COPY_FILES += \
    $(instaboot_config_file):system/etc/instaboot_config.xml

instaboot_rc := $(wildcard $(LOCAL_PATH)/instaboot.rc)
ifeq ($(instaboot_rc),)
instaboot_rc := device/khadas/common/instaboot.rc
endif

PRODUCT_COPY_FILES += \
    $(instaboot_rc):root/instaboot.rc

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += instabootserver
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1

ifeq ($(TARGET_BUILD_CTS), true)

ADDITIONAL_DEFAULT_PROPERTIES += ro.vold.forceencryption=1
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.voice_recognizers.xml:system/etc/permissions/android.software.voice_recognizers.xml \
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml

ifeq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/khadas/common/android.software.atv.xml:system/etc/permissions/android.software.google_atv.xml
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original \
	media.amplayer.widevineenable=true

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Contacts \
    TvProvider \
    Bluetooth \
    DownloadProviderUi \
    Calendar \
    QuickSearchBox
else
PRODUCT_PACKAGES += \
    Dig \
	libfwdlockengine

endif

ifeq ($(TARGET_BUILD_NETFLIX), true)
PRODUCT_COPY_FILES += \
	device/khadas/common/droidlogic.software.netflix.xml:system/etc/permissions/android.software.netflix.xml
endif
