LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := recovery_amlogic.cpp

LOCAL_MODULE := librecovery_amlogic

LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES += bootable/recovery

LOCAL_C_INCLUDES += bootable/recovery/bootloader_message/include

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../

LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_STATIC_LIBRARIES += libfs_mgr libselinux

LOCAL_CFLAGS += -Wall

include $(BUILD_STATIC_LIBRARY)