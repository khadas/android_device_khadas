KERNEL_ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
CONFIG_DHD_USE_STATIC_BUF ?= y
PRODUCT_OUT=out/target/product/$(TARGET_PRODUCT)
TARGET_OUT=$(PRODUCT_OUT)/system

define bcmwifi-modules
	@echo "make wifi module KERNEL_ARCH is $(KERNEL_ARCH)"
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CONFIG_DHD_USE_STATIC_BUF=$(CONFIG_DHD_USE_STATIC_BUF) modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd.1.363.59.144.x.cn/dhd.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ/net/wireless/cfg80211.ko $(TARGET_OUT)/lib/
endef

AP6181:
	@echo "wifi module is AP6181"
	$(bcmwifi-modules)
AP6210:
	@echo "wifi module is AP6210"
	$(bcmwifi-modules)
AP6330:
	@echo "wifi module is AP6330"
	$(bcmwifi-modules)
AP6234:
	@echo "wifi module is AP6234"
	$(bcmwifi-modules)
AP6441:
	@echo "wifi module is AP6441"
	$(bcmwifi-modules)
AP6335:
	@echo "wifi module is AP6335"
	$(bcmwifi-modules)
AP6212:
	@echo "wifi module is AP6212"
	$(bcmwifi-modules)
AP62x2:
	@echo "wifi module is AP62x2"
	$(bcmwifi-modules)
AP6255:
	@echo "wifi module is AP6255"
	$(bcmwifi-modules)
bcm43341:
	@echo "wifi module is bcm43341"
	$(bcmwifi-modules)
bcm43241:
	@echo "wifi module is bcm43241"
	$(bcmwifi-modules)
bcm40181:
	@echo "wifi module is bcm40181"
	$(bcmwifi-modules)
bcm40183:
	@echo "wifi module is bcm40183"
	$(bcmwifi-modules)
bcm4354:
	@echo "wifi module is bcm4354"
	$(bcmwifi-modules)
bcm4356:
	@echo "wifi module is bcm4356"
	$(bcmwifi-modules)
bcm4358:
	@echo "wifi module is bcm4358"
	$(bcmwifi-modules)
bcm43458:
	@echo "wifi module is bcm43458"
	$(bcmwifi-modules)
define bcmd-usb-wifi-modules
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd-usb.1.201.88.27.x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/vendor/broadcom/btusb/btusb_1_6_29_1/ ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd-usb.1.201.88.27.x/bcmdhd.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/vendor/broadcom/btusb/btusb_1_6_29_1/btusb.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ/net/wireless/cfg80211.ko $(TARGET_OUT)/lib/
endef
AP6269:
	@echo "wifi module is AP6269"
	$(bcmd-usb-wifi-modules)
AP6242:
	@echo "wifi module is AP6242"
	$(bcmd-usb-wifi-modules)

multiwifi:
	@echo "make wifi module KERNEL_ARCH is $(KERNEL_ARCH)"
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd.1.363.59.144.x.cn ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CONFIG_DHD_USE_STATIC_BUF=y modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd.1.363.59.144.x.cn/dhd.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ/net/wireless/cfg80211.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ/net/mac80211/mac80211.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd-usb.1.201.88.27.x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd-usb.1.201.88.27.x/bcmdhd.ko $(TARGET_OUT)/lib/
