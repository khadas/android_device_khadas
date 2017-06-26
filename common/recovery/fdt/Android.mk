LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	fdt.c \
	fdt_ro.c \
	fdt_wip.c \
	fdt_sw.c \
	fdt_rw.c \
	fdt_strerror.c \
	fdt_empty_tree.c


LOCAL_MODULE := libfdt

LOCAL_CFLAGS += -Wall

include $(BUILD_STATIC_LIBRARY)
