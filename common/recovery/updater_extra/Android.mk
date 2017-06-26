LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := install_amlogic.cpp

LOCAL_MODULE := libinstall_amlogic

LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES += bootable/recovery

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../

LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_STATIC_LIBRARIES += libbootloader_message libfs_mgr libselinux

include $(BUILD_STATIC_LIBRARY)