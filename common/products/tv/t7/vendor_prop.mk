# Copyright (C) 2011 Amlogic Inc
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
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Set display related config
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.bdsuimode=true\
    ro.vendor.platform.has.mbxuimode=true \
    ro.vendor.platform.has.tvuimode=true \
    ro.vendor.platform.customize_tvsetting=true \
    ro.vendor.platform.has.realoutputmode=true \
    ro.vendor.platform.need.display.hdmicec=true

#platform support dolby vision
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolbyvision=true

#camera max to 720p
#PRODUCT_PROPERTY_OVERRIDES += \
    #ro.media.camera_preview.maxsize=1280x720 \
    #ro.media.camera_preview.limitedrate=1280x720x30,640x480x30,320x240x28

#camera max to 1080p
PRODUCT_PRODUCT_PROPERTIES += \
    ro.media.camera_preview.maxsize=1920x1080 \
    ro.media.camera_preview.limitedrate=1920x1080x30,1280x720x30,640x480x30,320x240x28 \
    ro.media.camera_preview.usemjpeg=1 \
    ro.vendor.camera_usb.faceback=true

# t962x3_ab301 support screen capture
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.screencontrol.porttype=1 \
    ro.vendor.screencontrol.maxbufsize=314572800

#if wifi Only
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.media_vol_steps=100

#if need pppoe
PRODUCT_PROPERTY_OVERRIDES += \
    ro.net.pppoe=true

#the prop is used for enable or disable
#DD+/DD force output when HDMI EDID is not supported
#by default,the force output mode is enabled.
#Note,please do not set the prop to true by default
#only for netflix,just disable the feature.so set the prop to true
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.disable.audiorawout=false

#Dolby DD+ decoder option
#this prop to for videoplayer display the DD+/DD icon when playback
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolby=true
#DTS decoder option
#display dts icon when playback
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dts=true
#DTS-HD support prop
#PRODUCT_PROPERTY_OVERRIDES += \
    #ro.vendor.platform.support.dtstrans=true \
    #ro.vendor.platform.support.dtsmulasset=true
#DTS-HD prop end
# Enable player buildin


#add for video boot, 1 means use video boot, others not .
PRODUCT_PROPERTY_OVERRIDES += \
    service.bootvideo=0

# Define drm for this device
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=1

#set memory upper limit for extractor process
PRODUCT_PRODUCT_PROPERTIES += \
    ro.media.maxmem=629145600

#map volume
PRODUCT_PRODUCT_PROPERTIES += \
    ro.audio.mapvalue=0,0,0,0

#adb
PRODUCT_PROPERTY_OVERRIDES += \
    service.adb.tcp.port=5555

#enable/disable afbc
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.afbcd.enable=1

#disable timeshift
PRODUCT_PROPERTY_OVERRIDES += \
    tv.dtv.tf.disable=true

# crypto volume
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode=aes-256-cts

#this property is used for Android TV audio
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.vendor.platform.is.tv=1

#bootvideo
#0                      |050
#^                      |
#|                      |
#0:bootanim             |
#1:bootanim + bootvideo |
#2:bootvideo + bootanim |
#3:bootvideo            |
#others:bootanim        |
#-----------------------|050
#050:default volume value, volume range 0~100
#note that the high position 0 can not be omitted
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.media.bootvideo=0050
endif

# platform digital tv standards
# atsc/dvb/isdb/sbtvd
# ro.vendor.platform.digitaltv.standards
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.digitaltv.standards=atsc

#support hardware av1 decoder
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.av1=true

#unsupport 4k
#PRODUCT_PRODUCT_PROPERTIES += \
#	media.amplayer.videolimiter=true

#used for controlling reference board's preview window,
#project's need disable it or can refer its implementation method.
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PROPERTY_OVERRIDES += \
    tv.need.droidlogic.preview_window=true
endif

ifeq ($(TARGET_BUILD_GOOGLE_ATV), false)
#USB wifi need to be disabled when suspending
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.wifi.suspend=false
endif

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

#support video_composer
PRODUCT_PROPERTY_OVERRIDES += \
    media.omx.display_mode=3

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omxvideo-optmize=1

#omx2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.support.omx2=true \
    vendor.media.omx.use.omx2=true \
    vendor.media.omx2.in_buffer=5 \
    vendor.media.omx2.support_mpeg=true \
    vendor.ionvideo.enable=1 \
    vendor.media.omx.dibypass.enable=false \
    vendor.media.omx.videolayerrotation.enable=false \
    vendor.omx2.nr.enable=true \
    vendor.omx2.di.localbuf.enable=true

#usb controller
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.controller=fdd00000.crgudc2

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.hwc.lcdpath=1

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.sys.hdmionly=true

#lmkd use minfree for kernel5.4
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.use_minfree_levels=true

PRODUCT_PROPERTY_OVERRIDES += ro.llk.enable=false

#audio dual spdif setting
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.dualspdif=true

#tv path use video_tunnel
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.fixed_tunnel=1