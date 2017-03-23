KERNEL_ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
PRODUCT_OUT=out/target/product/$(TARGET_PRODUCT)
TARGET_OUT=$(PRODUCT_OUT)/system

rtk_btusb:
	@echo "make rtk bluetooth module KERNEL_ARCH is $(KERNEL_ARCH)"
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/realtek/bluetooth/rtk_btusb ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CONFIG_BT_RTKBTUSB=m modules
	cp $(shell pwd)/hardware/realtek/bluetooth/rtk_btusb/rtk_btusb.ko $(TARGET_OUT)/lib/

