$(call inherit-product, device/khadas/common/core_amlogic.mk)

ifeq ($(TARGET_BUILD_LIVETV),true)
#TV input HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.input@1.0-impl \
    android.hardware.tv.input@1.0-service \
    vendor.amlogic.hardware.tvserver@1.0_vendor \
    tv_input.amlogic

# TV
PRODUCT_PACKAGES += \
    libtv \
    libtv_linker \
    libtvbinder \
    libtv_jni \
    tvserver \
    libtvplay \
    libvendorfont \
    libTVaudio \
    libntsc_decode \
    libzvbi \
    droidlogic-tv \
    droidlogic.tv.software.core.xml \
    TvProvider \
    DroidLogicTvInput \
    DroidLogicFactoryMenu \
    libjnidtvsubtitle
# CTC subtitle
PRODUCT_PACKAGES += \
    libsubtitlebinder

# DTV
PRODUCT_PACKAGES += \
    libam_adp \
    libam_mw \
    libam_ver \
    libam_sysfs \
    libam_adp_static \
    libam_mw_static

PRODUCT_PACKAGES += \
    busybox \
    utility_busybox

# LiveTv
PRODUCT_PACKAGES += \
    DroidLiveTvSettings
endif

# DTVKit
ifeq ($(PRODUCT_SUPPORT_DTVKIT), true)
SUPPORT_CAS = true
PRODUCT_PACKAGES += \
    inputsource \
    libdtvkit_jni \
    dtvkitserver \
    dtvkitserver_releaseinfo.txt \
    libicuuc_vendor \
    libicui18n_vendor \
    droidlogic-dtvkit \
    droidlogic.dtvkit.software.core.xml

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.video.show_first_frame_nosync=1
endif

PRODUCT_PACKAGES += \
    remotecfg

#screencontrol
PRODUCT_PACKAGES += \
    screencontrol \
    libscreencontrolservice \
    libscreencontrolclient \
    libscreencontrol_jni \
    videomediaconvertortest \
    tspacktest \
    screencatch

#Tvsettings
PRODUCT_PACKAGES += \
    DroidTvSettings

ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PACKAGES += \
    OTAUpgrade
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

MKDIR=$(shell mkdir $(TARGET_COPY_OUT_VENDOR)/usr/icu/)
$(MKDIR)
PRODUCT_COPY_FILES += \
    vendor/amlogic/common/prebuilt/icu/icudt60l.dat:$(TARGET_COPY_OUT_VENDOR)/usr/icu/icudt60l.dat

ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.live_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_tv.xml
endif

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/khadas/common/config/lowmemorykiller_2G.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_2G.txt \
	device/khadas/common/config/lowmemorykiller.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller.txt \
	device/khadas/common/config/lowmemorykiller_512M.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_512M.txt
endif

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

custom_keylayouts := $(wildcard device/khadas/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(notdir $(file)))

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

#bootvideo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootvideo.zip:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo.zip \
    $(LOCAL_PATH)/tv.mp4:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo

# Save memory
# dumpsys SurfaceFlinger | grep com.android.systemui.ImageWallpaper
# 16.00 KiB |   64 (  64) x   64 |    1 |       2B | 0x40000000000b00 | com.android.systemui.ImageWallpaper#0
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/default_wallpaper.png:$(TARGET_COPY_OUT_VENDOR)/etc/default_wallpaper.png

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.wallpaper=vendor/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
#ifeq ($(VERSION_ID),)
#export BUILD_NUMBER := $(shell date +%Y%m%d)
#else
#$(call inherit-product, $(VERSION_ID))
#endif

DISPLAY_BUILD_NUMBER := true

#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.display_mode=3
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.sf.omxvideo-optmize=1

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

#TV project, need use 8 ch 32 bit output.
TARGET_WITH_TV_AUDIO_MODE := true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.hdmi.keep_awake=false

#userdebug, eng, AOSP version default disable AVB
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
    BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 2
else
    ifeq ($(BOARD_COMPILE_ATV), false)
        BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 2
    endif
endif

#TV project, enable hwc uvm dettach
HWC_UVM_DETTACH := true
