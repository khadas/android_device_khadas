# Inherit from those products. Most specific first.
# Get some sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)

# Get the TTS language packs
$(call inherit-product-if-exists, external/svox/pico/lang/all_pico_languages.mk)

# Get a list of languages.
$(call inherit-product, build/target/product/locales_full.mk)

# Additional settings used in all AOSP builds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.config.ringtone=Ring_Synth_04.ogg \
    ro.config.notification_sound=pixiedust.ogg

# Put en_US first in the list, so make it default.
PRODUCT_LOCALES := en_US

# Include drawables for all densities
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi

PRODUCT_PACKAGES += \
    libWnnEngDic \
    libWnnJpnDic \
    libwnndict \
    WAPPushManager

PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
    PhotoTable
endif

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker
endif

PRODUCT_PACKAGES += \
    Camera2 \
    Gallery2 \
    OneTimeInitializer \
    Provision \
    SystemUI \
    WallpaperCropper

PRODUCT_PACKAGES += \
    clatd \
    clatd.conf \
    pppd \
    screenrecord

PRODUCT_PACKAGES += \
    librs_jni \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer \

PRODUCT_PACKAGES += \
    audio.primary.default \
    audio_policy.default \
    audio.dia_remote.default \
    local_time.default \
    vibrator.default \
    power.default

PRODUCT_PACKAGES += \
    local_time.default

PRODUCT_COPY_FILES += \
        frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf

PRODUCT_COPY_FILES += \
        device/khadas/common/ddr/ddr_window_64.ko:/system/lib/ddr_window_64.ko

PRODUCT_PROPERTY_OVERRIDES += \
    ro.carrier=unknown \
    net.tethering.noprovisioning=true

PRODUCT_PACKAGES += \
    BasicDreams \
    CalendarProvider \
    CaptivePortalLogin \
    CertInstaller \
    DocumentsUI \
    ExternalStorageProvider \
    FusedLocation \
    InputDevices \
    KeyChain \
    Keyguard \
    PacProcessor \
    libpac \
    ProxyHandler \
    Settings \
    DroidTvSettings \
    SharedStorageBackup \
    VpnDialogs

$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/dancing-script/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/carrois-gothic-sc/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/coming-soon/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/cutive-mono/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)
$(call inherit-product-if-exists, frameworks/webview/chromium/chromium.mk)
$(call inherit-product, build/target/product/core_base.mk)

#default hardware composer version is 2.0
TARGET_USES_HWC2 := true

ifneq ($(wildcard vendor/amlogic/frameworks/av/LibPlayer),)
    WITH_LIBPLAYER_MODULE := true
else
    WITH_LIBPLAYER_MODULE := false
endif

# set soft stagefright extractor&decoder as defaults
WITH_SOFT_AM_EXTRACTOR_DECODER := true

PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.render_dirty_regions=false \
    ro.hwui.texture_cache_size=64.0f \
    camera.disable_zsl_mode=1

# USB camera default face
PRODUCT_PROPERTY_OVERRIDES += \
    rw.camera.usb.faceback=true

SKIP_BOOT_JARS_CHECK = true

PRODUCT_BOOT_JARS += \
    droidlogic \
    droidlogic.frameworks.pppoe

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
    AppInstaller \
    FileBrowser \
    Miracast \
    RemoteIME \
    Launcher2 \
    MusicFX \
    LatinIME \
    Music
else
PRODUCT_PACKAGES += \
    LeanbackCustomizer
endif

PRODUCT_PACKAGES += \
    droidlogic \
    droidlogic-res \
    systemcontrol \
    OTAUpgrade \
    VideoPlayer \
    SubTitle    \
    systemcontrol_static \
    libsystemcontrolservice \
    libdig \
    BluetoothRemote

PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libds_jni \
    libsrec_jni \
    system_key_server \
    libwifi-hal \
    libwpa_client \
    libGLES_mali \
    network \
    sdptool \
    e2fsck \
    mkfs.exfat \
    mount.exfat \
    fsck.exfat \
    ntfs-3g \
    ntfsfix \
    mkntfs \
    gralloc.amlogic \
    power.amlogic \
    hwcomposer.amlogic \
    memtrack.amlogic \
    screen_source.amlogic

#glscaler and 3d format api
PRODUCT_PACKAGES += \
    libdisplaysetting

#native image player surface overlay so
PRODUCT_PACKAGES += \
    libsurfaceoverlay_jni

#native gif decode so
PRODUCT_PACKAGES += \
    libgifdecode_jni

PRODUCT_PACKAGES += libomx_av_core_alt \
    libOmxCore \
    libOmxVideo \
    libthreadworker_alt \
    libdatachunkqueue_alt \
    libOmxBase \
    libomx_framework_alt \
    libomx_worker_peer_alt \
    libfpscalculator_alt \
    libomx_clock_utils_alt \
    libomx_timed_task_queue_alt \
    libstagefrighthw \
    libsecmem \
    secmem \
    2c1a33c0-44cc-11e5-bc3b0002a5d5c51b

# Dm-verity
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_SYSTEM_VERITY_PARTITION = /dev/block/system
# Provides dependencies necessary for verified boot
PRODUCT_SUPPORTS_BOOT_SIGNER := true
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SUPPORTS_VERITY_FEC := true
# The dev key is used to sign boot and recovery images, and the verity
# metadata table. Actual product deliverables will be re-signed by hand.
# We expect this file to exist with the suffixes ".x509.pem" and ".pk8".
PRODUCT_VERITY_SIGNING_KEY := device/khadas/common/security/verity
ifneq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)
PRODUCT_PACKAGES += \
        verity_key.amlogic
endif
endif

#########################################################################
#
#                                                App optimization
#
#########################################################################
#ifeq ($(BUILD_WITH_APP_OPTIMIZATION),true)

PRODUCT_COPY_FILES += \
    device/khadas/common/optimization/liboptimization_32.so:system/lib/liboptimization.so \
    device/khadas/common/optimization/config:system/package_config/config

PRODUCT_PROPERTY_OVERRIDES += \
    ro.app.optimization=true

ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_COPY_FILES += \
    device/khadas/common/optimization/liboptimization_64.so:system/lib64/liboptimization.so
endif
#endif

#########################################################################
#
#                          Alarm white and black list
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/khadas/common/alarm/alarm_blacklist.txt:/system/etc/alarm_blacklist.txt \
    device/khadas/common/alarm/alarm_whitelist.txt:/system/etc/alarm_whitelist.txt

#########################################################################
#
#                                                Secure OS
#
#########################################################################
ifeq ($(TARGET_USE_OPTEEOS),true)
PRODUCT_PACKAGES += \
	optee_armtz \
	optee \
	tee-supplicant \
	libteec \
	tee_helloworld \
	tee_crypto \
	tee_xtest \
	tdk_auto_test \
	tee_helloworld_ta \
	tee_fail_test_ta \
	tee_crypt_ta \
	tee_os_test_ta \
	tee_rpc_test_ta \
	tee_sims_ta \
	tee_storage_ta \
	tee_storage_benchmark_ta \
	tee_concurrent_ta \
	tee_concurrent_large_ta

ifeq ($(TARGET_USE_HW_KEYMASTER),true)
PRODUCT_PACKAGES += \
	keystore.amlogic
endif
endif

#########################################################################
#
#                                     OTA PROPERTY
#
#########################################################################
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.firmware=00502001 \
    ro.product.otaupdateurl=http://10.28.11.53:8080/otaupdate/update
