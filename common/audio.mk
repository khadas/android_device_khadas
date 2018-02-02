#
# Copyright (C) 2012 The Android Open Source Project
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

PRODUCT_PACKAGES += \
    audio_policy.default \
    audio.primary.amlogic \
    audio.hdmi.amlogic \
    audio.r_submix.default \
    acoustics.default \
    audio_firmware \
    libparameter

#PRODUCT_COPY_FILES += \
#    $(TARGET_PRODUCT_DIR)/audio_policy.conf:system/etc/audio_policy.conf \
#    $(TARGET_PRODUCT_DIR)/audio_effects.conf:system/etc/audio_effects.conf

#arm audio decoder lib
soft_adec_libs := $(shell ls hardware/amlogic/LibAudio/amadec/acodec_lib_android_n)
PRODUCT_COPY_FILES += $(foreach file, $(soft_adec_libs), \
        hardware/amlogic/LibAudio/amadec/acodec_lib_android_n/$(file):system/lib/$(file))
        
#audio data ko 
PRODUCT_COPY_FILES += device/khadas/common/audio/audio_data.ko:system/lib/audio_data.ko        

#configurable audio policy
#USE_CONFIGURABLE_AUDIO_POLICY := 1
#USE_XML_AUDIO_POLICY_CONF := 1
configurable_audiopolicy_xmls := device/khadas/common/audio/
PRODUCT_COPY_FILES += \
    $(configurable_audiopolicy_xmls)audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)dia_remote_audio_policy_configuration.xml:system/etc/dia_remote_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)huitong_remote_audio_policy_configuration.xml:system/etc/huitong_remote_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml \
    $(configurable_audiopolicy_xmls)default_volume_tables.xml:system/etc/default_volume_tables.xml

################################################################################## alsa

ifeq ($(BOARD_ALSA_AUDIO),legacy)

PRODUCT_COPY_FILES += \
	$(TARGET_PRODUCT_DIR)/asound.conf:system/etc/asound.conf \
	$(TARGET_PRODUCT_DIR)/asound.state:system/etc/asound.state

BUILD_WITH_ALSA_UTILS := true

PRODUCT_PACKAGES += \
    alsa.default \
    libasound \
    alsa_aplay \
    alsa_ctl \
    alsa_amixer \
    alsainit-00main \
    alsalib-alsaconf \
    alsalib-pcmdefaultconf \
    alsalib-cardsaliasesconf
endif

################################################################################## tinyalsa

ifeq ($(BOARD_ALSA_AUDIO),tiny)

BUILD_WITH_ALSA_UTILS := false

# Audio
PRODUCT_PACKAGES += \
    audio.usb.default \
    libtinyalsa \
    tinyplay \
    tinycap \
    tinymix \
    audio.usb.amlogic
endif

##################################################################################
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/mixer_paths.xml),)
    PRODUCT_COPY_FILES += \
        $(TARGET_PRODUCT_DIR)/mixer_paths.xml:system/etc/mixer_paths.xml
else
    ifeq ($(BOARD_AUDIO_CODEC),rt5631)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/rt5631_mixer_paths.xml:system/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),rt5616)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/rt5616_mixer_paths.xml:system/etc/mixer_paths.xml
    endif 

    ifeq ($(BOARD_AUDIO_CODEC),wm8960)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/wm8960_mixer_paths.xml:system/etc/mixer_paths.xml
    endif
    
    ifeq ($(BOARD_AUDIO_CODEC),dummy)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/dummy_mixer_paths.xml:system/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),m8_codec)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/m8codec_mixer_paths.xml:system/etc/mixer_paths.xml
    endif
    
    ifeq ($(BOARD_AUDIO_CODEC),amlpmu3)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/amlpmu3_mixer_paths.xml:system/etc/mixer_paths.xml
    endif
endif
