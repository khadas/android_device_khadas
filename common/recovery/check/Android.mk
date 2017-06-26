LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := security.c dtbcheck.c

LOCAL_MODULE := libsecurity

LOCAL_C_INCLUDES += bootable/recovery

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../

LOCAL_STATIC_LIBRARIES := libmtdutils libcutils libminzip libselinux

LOCAL_CLANG := true

LOCAL_CFLAGS += -Wall

ifeq ($(OTA_UP_PART_NUM_CHANGED), true)
LOCAL_CFLAGS += -DSUPPORT_PARTNUM_CHANGE
endif

include $(BUILD_STATIC_LIBRARY)
