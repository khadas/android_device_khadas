

DEVICE_PRODUCT_PATH := device/khadas/t7_an400


KERNEL_ROOTDIR := common
KERNEL_KO_OUT := $(PRODUCT_OUT)/obj/lib_vendor
INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --header_version $(BOARD_BOOT_HEADER_VERSION)

## build kernel and modules here
include device/khadas/common/build_kernel_modules.mk
