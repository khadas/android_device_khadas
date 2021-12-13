#!/bin/bash

BOOTLOARED_VERSION_FILE=$1/build/include/generated/timestamp_autogenerated.h
BOOTLOARED_VERSION=$(cat ${BOOTLOARED_VERSION_FILE} | tail -n 1 | cut -f 2 -d '"')

echo "**********************BOOTLOARED_VERSION: ${BOOTLOARED_VERSION}"

if [ -f $2/board-info.txt ]
then
	sed -i "s/require version-bootloader=.*/require version-bootloader=01.01.${BOOTLOARED_VERSION}/g" $2/board-info.txt
fi

if [ -f $2/prebuilt/bootloader/board-info.txt ]
then
	sed -i "s/require version-bootloader=.*/require version-bootloader=01.01.${BOOTLOARED_VERSION}/g" $2/prebuilt/bootloader/board-info.txt
fi

if [ -f $2/bootloader.img ]
then
	BOOTLOADER_SHA1_SIGN=$(sha1sum --tag $2/bootloader.img | cut -f 4 -d ' ')
	echo "${BOOTLOADER_SHA1_SIGN} 01.01.${BOOTLOARED_VERSION}" >> $2/bootloader.img.sha1
fi

if [ -f $2/bootloader_unsign.img ]
then
	BOOTLOADER_SHA1_UNSIGN=$(sha1sum --tag $2/bootloader_unsign.img | cut -f 4 -d ' ')
	echo "${BOOTLOADER_SHA1_UNSIGN} 01.01.${BOOTLOARED_VERSION}" >> $2/bootloader_unsign.img.sha1
fi

