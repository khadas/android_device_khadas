LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/recovery_extra/Android.mk \
        $(LOCAL_PATH)/ubootenv/Android.mk \
        $(LOCAL_PATH)/fdt/Android.mk \
        $(LOCAL_PATH)/check/Android.mk \
        $(LOCAL_PATH)/updater_extra/Android.mk