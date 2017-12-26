IMGPACK := $(BUILD_OUT_EXECUTABLES)/logo_img_packer$(BUILD_EXECUTABLE_SUFFIX)
PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/upgrade
AML_EMMC_BIN_GENERATOR := vendor/amlogic/tools/aml_upgrade/amlogic_emmc_bin_maker.sh
PRODUCT_COMMON_DIR := device/khadas/common/products/$(PRODUCT_TYPE)

ifeq ($(TARGET_NO_RECOVERY),true)
BUILT_IMAGES := boot.img u-boot.bin dtb.img
else
BUILT_IMAGES := boot.img recovery.img u-boot.bin dtb.img
endif
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	BUILT_IMAGES := $(addsuffix .encrypt, $(BUILT_IMAGES))
endif#ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

BUILT_IMAGES += system.img userdata.img

ifneq ($(AB_OTA_UPDATER),true)
BUILT_IMAGES += cache.img
endif

ifneq ($(BOARD_OLD_PARTITION),true)
BUILT_IMAGES += vendor.img
ifeq ($(BOARD_USES_ODMIMAGE),true)
BUILT_IMAGES += odm.img
endif
endif

# -----------------------------------------------------------------
# odm partition image
ifdef BOARD_ODMIMAGE_FILE_SYSTEM_TYPE
INTERNAL_ODMIMAGE_FILES := \
    $(filter $(TARGET_OUT_ODM)/%,$(ALL_DEFAULT_INSTALLED_MODULES))

odmimage_intermediates := \
    $(call intermediates-dir-for,PACKAGING,odm)
BUILT_ODMIMAGE_TARGET := $(PRODUCT_OUT)/odm.img
# We just build this directly to the install location.
INSTALLED_ODMIMAGE_TARGET := $(BUILT_ODMIMAGE_TARGET)

$(INSTALLED_ODMIMAGE_TARGET) : $(INTERNAL_USERIMAGES_DEPS) $(INTERNAL_ODMIMAGE_FILES) $(PRODUCT_OUT)/system.img
	$(call pretty,"Target odm fs image: $(INSTALLED_ODMIMAGE_TARGET)")
	@mkdir -p $(TARGET_OUT_ODM)
	@mkdir -p $(odmimage_intermediates) && rm -rf $(odmimage_intermediates)/odm_image_info.txt
	$(call generate-userimage-prop-dictionary, $(odmimage_intermediates)/odm_image_info.txt, skip_fsck=true)
	mkuserimg.sh -s $(PRODUCT_OUT)/odm $(INSTALLED_ODMIMAGE_TARGET) $(BOARD_ODMIMAGE_FILE_SYSTEM_TYPE) odm $(BOARD_ODMIMAGE_PARTITION_SIZE) -D $(PRODUCT_OUT)/system -L odm $(PRODUCT_OUT)/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin
	make_ext4fs -s -T -1 -S $(PRODUCT_OUT)/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin -L odm -l $(BOARD_ODMIMAGE_PARTITION_SIZE) -a odm $(INSTALLED_ODMIMAGE_TARGET) $(PRODUCT_OUT)/odm $(PRODUCT_OUT)/system
	$(hide) $(call assert-max-image-size,$(INSTALLED_ODMIMAGE_TARGET),$(BOARD_ODMIMAGE_PARTITION_SIZE))

.PHONY: odm_image
odm_image : $(INSTALLED_ODMIMAGE_TARGET)
$(call dist-for-goals, odm_image, $(INSTALLED_ODMIMAGE_TARGET))

endif

ifdef KERNEL_DEVICETREE
DTBTOOL := vendor/amlogic/tools/dtbTool

ifdef KERNEL_DEVICETREE_CUSTOMER_DIR
KERNEL_DEVICETREE_DIR := $(KERNEL_DEVICETREE_CUSTOMER_DIR)
else
KERNEL_DEVICETREE_DIR := arch/$(KERNEL_ARCH)/boot/dts/amlogic/
endif

KERNEL_DEVICETREE_SRC := $(addprefix $(KERNEL_ROOTDIR)/$(KERNEL_DEVICETREE_DIR), $(KERNEL_DEVICETREE) )
KERNEL_DEVICETREE_SRC := $(wildcard $(addsuffix .dtd, $(KERNEL_DEVICETREE_SRC)) $(addsuffix .dts, $(KERNEL_DEVICETREE_SRC)))

KERNEL_DEVICETREE_BIN := $(addprefix $(KERNEL_OUT)/$(KERNEL_DEVICETREE_DIR), $(KERNEL_DEVICETREE))
KERNEL_DEVICETREE_BIN := $(addsuffix .dtb, $(KERNEL_DEVICETREE_BIN))

INSTALLED_BOARDDTB_TARGET := $(PRODUCT_OUT)/dtb.img
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	INSTALLED_BOARDDTB_TARGET := $(INSTALLED_BOARDDTB_TARGET).encrypt
endif# ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

$(INSTALLED_BOARDDTB_TARGET) : $(KERNEL_DEVICETREE_SRC) $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(foreach aDts, $(KERNEL_DEVICETREE), \
		sed -i 's/^#include \"partition_.*/#include \"$(TARGET_PARTITION_DTSI)\"/' $(KERNEL_ROOTDIR)/$(KERNEL_DEVICETREE_DIR)/$(strip $(aDts)).dts; \
		if [ -f "$(KERNEL_ROOTDIR)/$(KERNEL_DEVICETREE_DIR)/$(aDts).dtd" ]; then \
			$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(strip $(aDts)).dtd; \
		fi;\
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(strip $(aDts)).dtb; \
	)
ifneq ($(strip $(word 2, $(KERNEL_DEVICETREE)) ),)
	$(hide) $(DTBTOOL) -o $@ -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/$(KERNEL_DEVICETREE_DIR)
else# elif dts num == 1
	cp -f $(KERNEL_DEVICETREE_BIN) $@
endif
	$(hide) $(call aml-secureboot-sign-bin, $@)
	@echo "Instaled $@"

.PHONY: dtbimage
dtbimage: $(INSTALLED_BOARDDTB_TARGET)

else #KERNEL_DEVICETREE undefined in Kernel.mk
INSTALLED_BOARDDTB_TARGET	   :=
endif # ifdef KERNEL_DEVICETREE


UPGRADE_FILES := \
        aml_sdc_burn.ini \
        ddr_init.bin \
	u-boot.bin.sd.bin  u-boot.bin.usb.bl2 u-boot.bin.usb.tpl \
        u-boot-comp.bin

ifneq ($(TARGET_USE_SECURITY_MODE),true)
UPGRADE_FILES += \
        platform.conf
else # secureboot mode
UPGRADE_FILES += \
        u-boot-usb.bin.aml \
        platform_enc.conf
endif

UPGRADE_FILES := $(addprefix $(TARGET_DEVICE_DIR)/upgrade/,$(UPGRADE_FILES))
UPGRADE_FILES := $(wildcard $(UPGRADE_FILES)) #extract only existing files for burnning

PACKAGE_CONFIG_FILE := update
ifeq ($(AB_OTA_UPDATER),true)
	PACKAGE_CONFIG_FILE := $(PACKAGE_CONFIG_FILE)_AB
endif # ifeq ($(AB_OTA_UPDATER),true)
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	PACKAGE_CONFIG_FILE := $(PACKAGE_CONFIG_FILE)_enc
endif # ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
PACKAGE_CONFIG_FILE := $(TARGET_DEVICE_DIR)/upgrade/$(PACKAGE_CONFIG_FILE).conf

ifeq ($(wildcard $(PACKAGE_CONFIG_FILE)),)
ifeq ($(BOARD_OLD_PARTITION),true)
	PACKAGE_CONFIG_FILE := $(TARGET_DEVICE_DIR)/product/upgrade_3.14/$(notdir $(PACKAGE_CONFIG_FILE))
else
	PACKAGE_CONFIG_FILE := $(TARGET_DEVICE_DIR)/product/upgrade_4.9/$(notdir $(PACKAGE_CONFIG_FILE))
endif
endif ## ifeq ($(wildcard $(TARGET_DEVICE_DIR)/upgrade/$(PACKAGE_CONFIG_FILE)))
UPGRADE_FILES += $(PACKAGE_CONFIG_FILE)

ifneq ($(TARGET_AMLOGIC_RES_PACKAGE),)
INSTALLED_AML_LOGO := $(PRODUCT_UPGRADE_OUT)/logo.img
$(INSTALLED_AML_LOGO): $(IMGPACK) $(wildcard $(TARGET_AMLOGIC_RES_PACKAGE)/*)
	@echo "generate $(INSTALLED_AML_LOGO)"
	$(hide) mkdir -p $(PRODUCT_UPGRADE_OUT)/logo
	$(hide) rm -rf $(PRODUCT_UPGRADE_OUT)/logo/*
	@cp -rf $(TARGET_AMLOGIC_RES_PACKAGE)/* $(PRODUCT_UPGRADE_OUT)/logo
	$(hide) $(IMGPACK) -r $(PRODUCT_UPGRADE_OUT)/logo $@
	@echo "Installed $@"
else
INSTALLED_AML_LOGO :=
endif

.PHONY: logoimg
logoimg: $(INSTALLED_AML_LOGO)

ifneq ($(BOARD_AUTO_COLLECT_MANIFEST),false)
BUILD_TIME := $(shell date +%Y-%m-%d--%H-%M)
INSTALLED_MANIFEST_XML := $(PRODUCT_OUT)/manifests/manifest-$(BUILD_TIME).xml
$(INSTALLED_MANIFEST_XML):
	$(hide) mkdir -p $(PRODUCT_OUT)/manifests
	$(hide) mkdir -p $(PRODUCT_OUT)/upgrade
	repo manifest -r -o $(INSTALLED_MANIFEST_XML)
	$(hide) cp $(INSTALLED_MANIFEST_XML) $(PRODUCT_OUT)/upgrade/manifest.xml

.PHONY:build_manifest
build_manifest:$(INSTALLED_MANIFEST_XML)
else
INSTALLED_MANIFEST_XML :=
endif

INSTALLED_AML_USER_IMAGES :=
ifeq ($(TARGET_BUILD_USER_PARTS),true)
define aml-mk-user-img-template
INSTALLED_AML_USER_IMAGES += $(2)
$(eval tempUserSrcDir := $$($(strip $(1))_PART_DIR))
$(2): $(call intermediates-dir-for,ETC,file_contexts.bin)/file_contexts.bin $(MAKE_EXT4FS) $(shell find $(tempUserSrcDir) -type f)
	@echo $(MAKE_EXT4FS) -s -S $$< -l $$($(strip $(1))_PART_SIZE) -a $(1) $$@  $(tempUserSrcDir) && \
	$(MAKE_EXT4FS) -s -S $$< -l $$($(strip $(1))_PART_SIZE) -a $(1) $$@  $(tempUserSrcDir)
endef
.PHONY:contexts_add
contexts_add:$(TARGET_ROOT_OUT)/file_contexts
	$(foreach userPartName, $(BOARD_USER_PARTS_NAME), \
		$(shell sed -i "/\/$(strip $(userPartName))/d" $< && \
		echo -e "/$(strip $(userPartName))(/.*)?      u:object_r:system_file:s0" >> $<))
$(foreach userPartName, $(BOARD_USER_PARTS_NAME), \
	$(eval $(call aml-mk-user-img-template, $(userPartName),$(PRODUCT_OUT)/$(userPartName).img)))

define aml-user-img-update-pkg
	ln -sf $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/$(1).img $(PRODUCT_UPGRADE_OUT)/$(1).img && \
	sed -i "/file=\"$(1)\.img\"/d" $(2) && \
	echo -e "file=\"$(1).img\"\t\tmain_type=\"PARTITION\"\t\tsub_type=\"$(1)\"" >> $(2) ;
endef

.PHONY: aml_usrimg
aml_usrimg :$(INSTALLED_AML_USER_IMAGES)
endif # ifeq ($(TARGET_BUILD_USER_PARTS),true)

INSTALLED_AMLOGIC_BOOTLOADER_TARGET := $(PRODUCT_OUT)/u-boot.bin
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	INSTALLED_AMLOGIC_BOOTLOADER_TARGET := $(INSTALLED_AMLOGIC_BOOTLOADER_TARGET).encrypt
endif# ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

$(INSTALLED_AMLOGIC_BOOTLOADER_TARGET) : $(TARGET_DEVICE_DIR)/u-boot.bin
	$(hide) cp $< $(PRODUCT_OUT)/u-boot.bin
	$(hide) $(call aml-secureboot-sign-bootloader, $@)
	@echo "make $@: bootloader installed end"

ifeq ($(TARGET_SUPPORT_USB_BURNING_V2),true)
INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/update.img

PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/$(notdir $(PACKAGE_CONFIG_FILE))

ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)
  SYSTEMIMG_INTERMEDIATES := $(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates/system.img.
  SYSTEMIMG_INTERMEDIATES := $(SYSTEMIMG_INTERMEDIATES)verity_table.bin $(SYSTEMIMG_INTERMEDIATES)verity.img
  define security_dm_verity_conf
	  @echo "copy verity.img and verity_table.bin"
	  @sed -i "/verity_table.bin/d" $(PACKAGE_CONFIG_FILE)
	  @sed -i "/verity.img/d" $(PACKAGE_CONFIG_FILE)
	  $(hide) \
		sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"system.img.verity.img\"\t\tmain_type=\"img\"\t\tsub_type=\"verity\"/" $(PACKAGE_CONFIG_FILE); \
		sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"system.img.verity_table.bin\"\t\tmain_type=\"bin\"\t\tsub_type=\"verity_table\"/" $(PACKAGE_CONFIG_FILE);
	  cp $(SYSTEMIMG_INTERMEDIATES) $(PRODUCT_UPGRADE_OUT)/
  endef #define security_dm_verity_conf
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)

ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
define aml-secureboot-sign-bootloader
	@echo -----aml-secureboot-sign-bootloader ------
	$(hide) $(PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER) --input $(basename $(1)) --output $(1)
	@echo ----- Made aml secure-boot singed bootloader: $(1) --------
endef #define aml-secureboot-sign-bootloader
define aml-secureboot-sign-kernel
	@echo -----aml-secureboot-sign-kernel ------
	$(hide) mv -f $(1) $(basename $(1))
	$(hide) $(PRODUCT_AML_SECUREBOOT_SIGNIMAGE) --input $(basename $(1)) --output $(1)
	@echo ----- Made aml secure-boot singed bootloader: $(1) --------
endef #define aml-secureboot-sign-kernel
define aml-secureboot-sign-bin
	@echo -----aml-secureboot-sign-bin------
	$(hide) mv -f $(1) $(basename $(1))
	$(hide) $(PRODUCT_AML_SECUREBOOT_SIGBIN) --input $(basename $(1)) --output $(1)
	@echo ----- Made aml secure-boot singed bin: $(1) --------
endef #define aml-secureboot-sign-bin
endif# ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

.PHONY:aml_upgrade
aml_upgrade:$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): \
	$(addprefix $(PRODUCT_OUT)/,$(BUILT_IMAGES)) \
	$(UPGRADE_FILES) \
	$(INSTALLED_AML_USER_IMAGES) \
	$(INSTALLED_AML_LOGO) \
	$(INSTALLED_MANIFEST_XML) \
	$(TARGET_USB_BURNING_V2_DEPEND_MODULES)
	mkdir -p $(PRODUCT_UPGRADE_OUT)
	$(hide) $(foreach file,$(UPGRADE_FILES), \
		echo cp $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
		cp -f $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
		)
	$(hide) $(foreach file,$(BUILT_IMAGES), \
		echo ln -sf $(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
		ln -sf $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
		)
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	$(hide) rm -f $(PRODUCT_UPGRADE_OUT)/u-boot.bin.encrypt.*
	$(hide) $(ACP) $(PRODUCT_OUT)/u-boot.bin.encrypt.* $(PRODUCT_UPGRADE_OUT)/
	ln -sf $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/dtb.img $(PRODUCT_UPGRADE_OUT)/dtb.img
	ln -sf $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/u-boot.bin.encrypt.efuse $(PRODUCT_UPGRADE_OUT)/SECURE_BOOT_SET
endif# ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	$(security_dm_verity_conf)
	$(update-aml_upgrade-conf)
	$(hide) $(foreach userPartName, $(BOARD_USER_PARTS_NAME), \
		$(call aml-user-img-update-pkg,$(userPartName),$(PACKAGE_CONFIG_FILE)))
	@echo "Package: $@"
	@echo ./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE)  $(PRODUCT_UPGRADE_OUT)/ $@
	./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE)  $(PRODUCT_UPGRADE_OUT)/ $@
	@echo " $@ installed"
else
#none
INSTALLED_AML_UPGRADE_PACKAGE_TARGET :=
endif

INSTALLED_AML_FASTBOOT_ZIP := $(PRODUCT_OUT)/$(TARGET_PRODUCT)-fastboot-$(BUILD_NUMBER).zip

FASTBOOT_IMAGES := android-info.txt system.img

ifeq ($(TARGET_NO_RECOVERY),true)
FASTBOOT_IMAGES += boot.img
else
FASTBOOT_IMAGES += boot.img recovery.img
endif

ifneq ($(BOARD_OLD_PARTITION),true)
FASTBOOT_IMAGES += vendor.img
ifeq ($(BOARD_USES_ODMIMAGE),true)
FASTBOOT_IMAGES += odm.img
endif
endif

.PHONY:aml_fastboot_zip
aml_fastboot_zip:$(INSTALLED_AML_FASTBOOT_ZIP)
$(INSTALLED_AML_FASTBOOT_ZIP): $(addprefix $(PRODUCT_OUT)/,$(FASTBOOT_IMAGES))
	echo "install $@"
	cd $(PRODUCT_OUT); zip -r $(TARGET_PRODUCT)-fastboot-$(BUILD_NUMBER).zip $(FASTBOOT_IMAGES)

droidcore: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML) $(INSTALLED_AML_FASTBOOT_ZIP)
otapackage: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML) $(INSTALLED_AML_FASTBOOT_ZIP)

