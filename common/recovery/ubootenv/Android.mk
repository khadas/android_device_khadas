LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := uboot_env.c set_display_mode.cpp

LOCAL_MODULE := libenv

LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES += vendor/amlogic/frameworks/services/systemcontrol
LOCAL_C_INCLUDES += bootable/recovery

LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_STATIC_LIBRARIES += libsystemcontrol_static liblog libcutils libstdc++ libc libbz

include $(BUILD_STATIC_LIBRARY)
