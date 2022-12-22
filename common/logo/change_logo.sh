#!/system/bin/sh
echo "change logo !!!!!!!!!!!!!!!!!!!!!!!!!"
dd if=/dev/block/logo of=/data/logo.img
mkdir /data/logo
logo_img_packer -d /data/logo.img /data/logo
minigzip -c /data//bootup.bmp >  /data/bootup
cp /data/bootup /data/logo//bootup
logo_img_packer -r  /data/logo /data/logo.img
 dd if=/data/logo.img of=/dev/block/logo

