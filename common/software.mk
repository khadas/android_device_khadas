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

ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
PRODUCT_COPY_FILES += \
    $(instaboot_rc):root/instaboot.rc
else
PRODUCT_COPY_FILES += \
    $(instaboot_rc):recovery/root/instaboot.rc
endif

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += instabootserver
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1

ifeq ($(TARGET_BUILD_CTS), true)

#ADDITIONAL_DEFAULT_PROPERTIES += ro.vold.forceencryption=1
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:system/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:system/etc/permissions/android.software.voice_recognizers.xml

ifeq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/khadas/common/android.software.google_atv.xml:system/etc/permissions/android.software.google_atv.xml
PRODUCT_PACKAGE_OVERLAYS += device/khadas/common/atv_gms_overlay
PRODUCT_PACKAGES += \
    TvProvider \
    GooglePackageInstaller \
    com.android.media.tv.remoteprovider.xml \
    com.android.media.tv.remoteprovider
$(call add-clean-step, rm -rf $(OUT_DIR)/system/etc/permissions/android.hardware.camera.front.xml)
$(call add-clean-step, rm -rf $(OUT_DIR)/system/priv-app/DLNA)

else
PRODUCT_PACKAGE_OVERLAYS += device/khadas/common/aosp_gms_overlay
PRODUCT_PACKAGES += \
    QuickSearchBox \
    Contacts \
    Calendar \
    BlockedNumberProvider \
    BookmarkProvider \
    MtpDocumentsProvider \
    DownloadProviderUi
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original \
    media.amplayer.widevineenable=true

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Bluetooth \
    PrintSpooler

else
PRODUCT_PACKAGES += \
    Dig \
    libfwdlockengine

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=force_land

endif

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.device_admin.xml:system/etc/permissions/android.software.device_admin.xml
PRODUCT_PACKAGES += \
    ManagedProvisioning
endif

ifeq ($(TARGET_BUILD_NETFLIX), true)
PRODUCT_COPY_FILES += \
	device/khadas/common/droidlogic.software.netflix.xml:system/etc/permissions/droidlogic.software.netflix.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.nrdp.validation=ninja_4
endif

$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)
