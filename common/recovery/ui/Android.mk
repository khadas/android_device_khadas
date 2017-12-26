LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := amlogic_ui.cpp

LOCAL_MODULE := libamlogic_ui

LOCAL_C_INCLUDES += \
    bootable/recovery \
    system/vold \
    system/core/adb \
    device/khadas/common/recovery

LOCAL_C_INCLUDES += system/core/base/include

LOCAL_C_INCLUDES += bootable/recovery/bootloader_message/include

LOCAL_STATIC_LIBRARIES := \
    librecovery_amlogic \
    libenv \
    libsystemcontrol_static

LOCAL_MODULE_TAGS := eng

#LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_CFLAGS += -Wall

include $(BUILD_STATIC_LIBRARY)
