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
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Contacts \
    TvProvider \
    Bluetooth \
    DownloadProviderUi \
    Calendar \
    QuickSearchBox
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml
else
PRODUCT_PACKAGES += \
    Dig

endif

ifeq ($(TARGET_BUILD_NETFLIX), true)
PRODUCT_COPY_FILES += \
	device/khadas/common/android.software.netflix.xml:system/etc/permissions/android.software.netflix.xml
endif
