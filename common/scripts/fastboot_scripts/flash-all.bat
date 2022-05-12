@ECHO OFF
:: Copyright 2012 The Android Open Source Project
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

PATH=%PATH%;"%SYSTEMROOT%\System32"
adb reboot bootloader
fastboot flashing unlock
fastboot flash bootloader bootloader.img
fastboot flash bootloader-boot0 bootloader.img
fastboot flash bootloader-boot1 bootloader.img
fastboot flash dts dt.img
fastboot erase env
fastboot erase misc
fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul
fastboot flashing unlock
fastboot flash dtbo dtbo.img
fastboot -w
fastboot erase param
fastboot erase tee
fastboot flash vbmeta vbmeta.img
fastboot flash logo logo.img
if exist odm_ext.img (
fastboot flash odm_ext odm_ext.img
)
if exist oem.img (
fastboot flash oem oem.img
)
if exist vbmeta_system.img (
fastboot flash vbmeta_system vbmeta_system.img
)
fastboot flash boot boot.img
if exist recovery.img (
fastboot flash recovery recovery.img
)
if exist vendor_boot.img (
fastboot flash vendor_boot vendor_boot.img
)
fastboot reboot-fastboot
ping -n 10 127.0.0.1 >nul
fastboot flash super super_empty_all.img
fastboot flash odm odm.img
fastboot flash system system.img
fastboot flash system_ext system_ext.img
fastboot flash vendor vendor.img
fastboot flash product product.img
fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul
fastboot flashing lock
fastboot reboot

echo Press any key to exit...
pause >nul
exit
