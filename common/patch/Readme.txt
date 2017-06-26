patch的路径位于device/amlogic/common/patch
patch命名方式如下：
以bootable/recovery为例:
生成patch:
cd bootable/recovery
git format-patch -2
得到两个patch:   0001-PD-140761-fix-bug-when-upgrade-from-6.0-openlinux-to.patch   (这个提交在前，需要先打)
                           0002-PD-141165-support-upgrade-with-partition-num-changed.patch
然后把这两个patch重命名后放到device/amlogic/common/patch目录
mv 0001-PD-140761-fix-bug-when-upgrade-from-6.0-openlinux-to.patch ../../device/amlogic/common/patch/bootable#recovery#0001.patch
mv 0002-PD-141165-support-upgrade-with-partition-num-changed.patch ../../device/amlogic/common/patch/bootable#recovery#0002.patch
git仓库相对于项目根目录的路径必须包含在patch的名字中