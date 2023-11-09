#
# Copyright (C) 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_DIR := kvim3

ifneq ($(ANDROID_BUILD_TYPE), 64)
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_ABI := arm64-v8a

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
endif

TARGET_USES_64_BIT_BINDER := true

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true

TARGET_BOARD_PLATFORM := w400
TARGET_BOOTLOADER_BOARD_NAME := w400

# Graphics & Display
USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
MAX_VIRTUAL_DISPLAY_DIMENSION := 1920
TARGET_APP_LAYER_USE_CONTINUOUS_BUFFER := false
TARGET_USE_DEFAULT_HDR_PROPERTY := true


#MESONHWC CONFIG
USE_HWC2 := true
#panel does not support AFBC in default
HWC_PRIMARY_DISP_SUPPORT_AFBC := false
HWC_EXTEND_DISP_SUPPORT_AFBC := true

include hardware/amlogic/gralloc/gralloc.device.mk

include hardware/amlogic/hwcomposer/hwcomposer.device.mk

# Camera
USE_CAMERA_STUB := false
BOARD_HAVE_FRONT_CAM := false
BOARD_HAVE_BACK_CAM := false
BOARD_USE_USB_CAMERA := true
IS_CAM_NONBLOCK := true
BOARD_HAVE_FLASHLIGHT := false
BOARD_HAVE_HW_JPEGENC := true
#IS_ISP_CAMERA := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
BOARD_FLASH_BLOCK_SIZE := 4096

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDORIMAGE := true
TARGET_COPY_OUT_VENDOR := vendor

BOARD_SYSTEMSDK_VERSIONS := 30

ifneq ($(BOARD_BUILD_SYSTEM_ROOT_IMAGE), true)
BOARD_ROOT_EXTRA_FOLDERS += odm
endif

ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
BUILDING_SYSTEM_EXT_IMAGE := true
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
endif

ifeq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 25165824
endif

ifeq ($(BOARD_USES_ODM_EXTIMAGE),true)
BOARD_ODM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODM_EXTIMAGE_PARTITION_SIZE := 16777216
endif

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
ifeq ($(AB_OTA_UPDATER),true)
ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
BOARD_SUPER_PARTITION_SIZE := 3363831808
else
BOARD_SUPER_PARTITION_SIZE := 1887436800
endif
else
BOARD_SUPER_PARTITION_SIZE := 1677721600
endif
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true

BOARD_SUPER_PARTITION_GROUPS := amlogic_dynamic_partitions

#dynamic partition size need less than super partition size
#reserve 10M
ifeq ($(AB_OTA_UPDATER)_$(TARGET_BUILD_KERNEL_4_9), true_false)
BOARD_AMLOGIC_DYNAMIC_PARTITIONS_SIZE := 1876951040
else
BOARD_AMLOGIC_DYNAMIC_PARTITIONS_SIZE := 1667235840
endif

BOARD_AMLOGIC_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product odm
ifneq ($(TARGET_BUILD_KERNEL_4_9),true)
BOARD_AMLOGIC_DYNAMIC_PARTITIONS_PARTITION_LIST += system_ext
endif

BOARD_EXT4_SHARE_DUP_BLOCKS := true

BOARD_KERNEL_CMDLINE += androidboot.dynamic_partitions=true

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
endif

ifeq ($(BUILD_WITH_UDC), true)
BOARD_ROOT_EXTRA_FOLDERS += metadata
endif

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_ODMIMAGE := true

BOARD_USES_METADATA_PARTITION := true

BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product

# Allow passing `--second` to mkbootimg via 2ndbootloader.
ifneq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
TARGET_BOOTLOADER_IS_2ND := true
endif

#BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true
#BOARD_DO_NOT_STRIP_VENDOR_MODULES := true

BOARD_DTBIMAGE_PARTITION_SIZE := 258048

ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
ifeq ($(AB_OTA_UPDATER),true)
BOARD_BOOTIMAGE_PARTITION_SIZE := 25165824
else
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
endif
else
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
endif

BOARD_DTBOIMG_PARTITION_SIZE := 2097152

BOARD_KERNEL_CMDLINE += androidboot.dtbo_idx=0

# add androidboot.boot_devices for func GetBlockDeviceSymlinks
# to create a new link as /dev/block/by-name/xxx (partition names)
# Because avb Verified will open the path /dev/block/by-name/vbmeta
ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
BOARD_KERNEL_CMDLINE += "androidboot.boot_devices=ffe07000.emmc"
else
BOARD_KERNEL_CMDLINE += "androidboot.boot_devices=soc/ffe07000.mmc"
endif

ifneq ($(USE_USB_AS_HOST),true)
BOARD_KERNEL_CMDLINE += "otg_device=1"
endif

# Android R will use uvm
BOARD_KERNEL_CMDLINE += "use_uvm=1"

ifeq ($(BOARD_BUILD_DISABLED_VBMETAIMAGE), true)
ifeq ($(BOARD_BUILD_SYSTEM_ROOT_IMAGE), true)
ifneq ($(AB_OTA_UPDATER),true)
BOARD_KERNEL_CMDLINE += "root=/dev/mmcblk0p18"
endif
endif
endif

TARGET_SUPPORT_USB_BURNING_V2 := true
TARGET_AMLOGIC_RES_PACKAGE := device/khadas/$(PRODUCT_DIR)/logo_img_files

#BOARD_HAL_STATIC_LIBRARIES := libhealthd.mboxdefault

USE_E2FSPROGS := true

BOARD_KERNEL_BASE := 0x0
ifneq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
BOARD_KERNEL_OFFSET := 0x1080000
else
BOARD_KERNEL_OFFSET := 0x2080000
endif

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true
TARGET_USE_BLOCK_BASE_UPGRADE := true
TARGET_OTA_UPDATE_DTB := true
#TARGET_RECOVERY_DISABLE_ADB_SIDELOAD := true
#TARGET_OTA_PARTITION_CHANGE := true


TARGET_COPY_OUT_ODM := odm

include device/khadas/common/sepolicy.mk

#MALLOC_SVELTE := true

#WITH_DEXPREOPT := true
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_USES_MKE2FS := true

PRODUCT_USE_VNDK_OVERRIDE := true
BOARD_VNDK_VERSION := current
ifneq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
BOARD_BOOT_HEADER_VERSION := 2
else
BOARD_BOOT_HEADER_VERSION := 3
endif
BOARD_INCLUDE_RECOVERY_DTBO := true

#voice record of SEI BT remote control
#BOARD_ENABLE_HBG := true

# introduced and must set in Q, also can used in P, see the ReadMe.txt at below dir:
TARGET_HOST_TOOL_PATH := vendor/amlogic/common/tools/host-tool
#put after all vendor configuration assigend evaluated.
include device/khadas/common/soong_config/soong_config.mk
#########################################################################
#
#           OEM Partitions based dynamic fingerprint
#
#########################################################################
ifeq ($(BOARD_USES_DYNAMIC_FINGERPRINT),true)
#Building raw OEM images with "make custom_images"
PRODUCT_CUSTOM_IMAGE_MAKEFILES := \
    device/khadas/kvim3/oem/oem.mk

#re-sign the raw ext4 OEM image
ifeq ($(filter $(MAKECMDGOALS),custom_images),)
BOARD_CUSTOMIMAGES_PARTITION_LIST := oem
endif
BOARD_AVB_OEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_OEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_OEM_ADD_HASHTREE_FOOTER_ARGS :=
BOARD_AVB_OEM_ROLLBACK_INDEX_LOCATION := 1
ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
BOARD_AVB_OEM_PARTITION_SIZE := 16777216
BOARD_AVB_OEM_IMAGE_LIST := \
    device/khadas/kvim3/oem/oem_4.9/oem.img
else
BOARD_AVB_OEM_PARTITION_SIZE := 33554432
BOARD_AVB_OEM_IMAGE_LIST := \
    device/khadas/kvim3/oem/oem.img
endif

#Set the OEM partition mounting flag to Read Only
TARGET_RECOVERY_FSTYPE_MOUNT_OPTIONS := ext4=ro
#Building OTAs for OEM properties
OEM_OTA_CONFIG := device/khadas/kvim3/oem/oem.prop
endif

#GKI firstlist and blacklist modules
RAMDISK_KERNEL_MODULES_LOAD_FIRSTLIST :=

RAMDISK_KERNEL_MODULES_LOAD_BLACKLIST := hifidsp.ko
