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
ifeq ($(ANDROID_BUILD_TYPE), 32)
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a9
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
endif

TARGET_USES_64_BIT_BINDER := true

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true

TARGET_BOARD_PLATFORM := gxl
TARGET_BOOTLOADER_BOARD_NAME := kvim

# Graphics & Display
USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
MAX_VIRTUAL_DISPLAY_DIMENSION := 1920
TARGET_APP_LAYER_USE_CONTINUOUS_BUFFER := true
TARGET_SUPPORT_SECURE_LAYER := false

# Camera
USE_CAMERA_STUB := false
BOARD_HAVE_FRONT_CAM := false
BOARD_HAVE_BACK_CAM := false
BOARD_USE_USB_CAMERA := true
IS_CAM_NONBLOCK := true
BOARD_HAVE_FLASHLIGHT := false
BOARD_HAVE_HW_JPEGENC := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1946157056
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
BOARD_FLASH_BLOCK_SIZE := 4096

ifneq ($(BOARD_OLD_PARTITION),true)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456
BOARD_USES_VENDORIMAGE := true
TARGET_COPY_OUT_VENDOR := vendor

BOARD_ROOT_EXTRA_FOLDERS := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_PARTITION_SIZE := 268435456
BOARD_USES_ODMIMAGE := true
else
GPU_MODS_OUT?=system/vendor/lib
endif


TARGET_SUPPORT_USB_BURNING_V2 := true
TARGET_AMLOGIC_RES_PACKAGE := device/khadas/kvim/logo_img_files

TARGET_RECOVERY_FSTAB := device/khadas/kvim/recovery/recovery.fstab

#BOARD_HAL_STATIC_LIBRARIES := libhealthd.mboxdefault

USE_E2FSPROGS := true

BOARD_KERNEL_BASE := 0x0
BOARD_KERNEL_OFFSET := 0x1080000

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true

TARGET_RELEASETOOLS_EXTENSIONS := device/khadas/common
TARGET_USE_BLOCK_BASE_UPGRADE := true
TARGET_OTA_UPDATE_DTB := true
#TARGET_RECOVERY_DISABLE_ADB_SIDELOAD := true
#TARGET_OTA_PARTITION_CHANGE := true

TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_UI_LIB += libamlogic_ui
TARGET_RECOVERY_UI_LIB += \
    librecovery_amlogic \
    libenv \
    libsystemcontrol_static
ifneq ($(AB_OTA_UPDATER),true)
TARGET_RECOVERY_UPDATER_LIBS := libinstall_amlogic
TARGET_RECOVERY_UPDATER_EXTRA_LIBS += libenv libsystemcontrol_static libsecurity libdtb
endif

include device/khadas/common/sepolicy.mk
include device/khadas/common/gpu/mali450-user-$(TARGET_ARCH).mk
#MALLOC_IMPL := dlmalloc

WITH_DEXPREOPT := true
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

DEVICE_MANIFEST_FILE := device/khadas/kvim/manifest.xml
#DEVICE_MATRIX_FILE   := device/khadas/common/compatibility_matrix.xml
