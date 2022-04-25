
###########################################################################################
# 1. project[x]          project name, as title only
# 2. soc[x]              soc name, as title only
# 3. hardware[x]         hardare platform name, as title only
# 4. module[x]           lunch name
# 5. uboot_path[x]       bootloader store path
# 6. uboot_exec_aosp[x]  build uboot aosp command
# 7. uboot_exec_drm[x]   build uboot drm command
# 8. kernel_exec[x]      build kernel command(do not include -t user)
# 9. android_exec[x]="TARGET_BUILD_KERNEL_4_9=true"  only if build 4.9 kernel need it.
# 10. kernel_addr[x]="export KERNEL_A32_SUPPORT=true"  only if build 32bit kernel need it.
###########################################################################################

###########################################################################################
# Franklin
project[1]="Franklin"
soc[1]="S905X2"
hardware[1]="U212"
module[1]="franklin"
uboot_path[1]="device/khadas/franklin"
uboot_exec_aosp[1]="./mk g12a_u212_v1  --vab --avb2"
uboot_exec_drm[1]="./mk g12a_u212_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[1]="./mk franklin -v 4.9"
android_exec[1]="TARGET_BUILD_KERNEL_4_9=true"
###########################################################################################

###########################################################################################
# Newton
project[2]="Newton"
soc[2]="S905X3"
hardware[2]="AC215"
module[2]="newton"
uboot_path[2]="device/khadas/newton"
uboot_exec_aosp[2]="./mk sm1_ac215_v1  --vab --avb2"
uboot_exec_drm[2]="./mk sm1_ac215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[2]="./mk newton -v 4.9"
android_exec[2]="TARGET_BUILD_KERNEL_4_9=true"
###########################################################################################

###########################################################################################
# Marconi
project[3]="Marconi"
soc[3]="T962X2"
hardware[3]="X301"
module[3]="marconi"
uboot_path[3]="device/khadas/marconi"
uboot_exec_aosp[3]="./mk tl1_x301_v1  --vab"
uboot_exec_drm[3]="./mk tl1_x301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tl1/bl32.img --vab --avb2"
kernel_exec[3]="./mk marconi -v 5.4"
###########################################################################################

###########################################################################################
# Dalton
project[4]="Dalton"
soc[4]="T962E2"
hardware[4]="AB311"
module[4]="dalton"
uboot_path[4]="device/khadas/marconi"
uboot_exec_aosp[4]="./mk tm2_t962e2_ab311_v1  --vab"
uboot_exec_drm[4]="./mk tm2_t962e2_ab311_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tm2/bl32.img --vab --avb2"
kernel_exec[4]="./mk dalton -v 5.4"
###########################################################################################

###########################################################################################
# Ohm
project[5]="Ohm"
soc[5]="S905X4"
hardware[5]="AH212"
module[5]="ohm"
uboot_path[5]="device/khadas/ohm"
uboot_exec_aosp[5]="./mk sc2_ah212  --vab --avb2"
uboot_exec_drm[5]="./mk sc2_ah212  --vab --avb2"
kernel_exec[5]="./mk ohm -v 5.4"
###########################################################################################

###########################################################################################
# REDI
project[6]="Redi"
soc[6]="T950D4/T950X4"
hardware[6]="AM301/AM311"
module[6]="redi"
uboot_path[6]="device/khadas/redi"
uboot_exec_aosp[6]="./mk t5d_am301_v1 --vab "
uboot_exec_drm[6]="./mk t5d_am301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/t5d/bl32.img --vab --avb2"
kernel_exec[6]="./mk redi -v 5.4"
###########################################################################################

###########################################################################################
# OPPEN
project[7]="Oppen"
soc[7]="S905Y4"
hardware[7]="AP222"
module[7]="oppen"
uboot_path[7]="device/khadas/oppen"
uboot_exec_aosp[7]="./mk s4_ap222  --vab --avb2"
uboot_exec_drm[7]="./mk s4_ap222  --vab --avb2"
kernel_exec[7]="./mk oppen -v 5.4"
###########################################################################################

###########################################################################################
# PLANCK
project[8]="Planck"
soc[8]="S805X2"
hardware[8]="AQ222"
module[8]="planck"
uboot_path[8]="device/khadas/planck"
uboot_exec_aosp[8]="./mk s4_aq222  --vab --avb2"
uboot_exec_drm[8]="./mk s4_aq222  --vab --avb2"
kernel_exec[8]="./mk planck -v 5.4"
kernel_addr[8]="export KERNEL_A32_SUPPORT=true"
###########################################################################################

###########################################################################################
# OHMCAS
project[9]="Ohmcas"
soc[9]="S905C2"
hardware[9]="AH232"
module[9]="ohmcas"
uboot_path[9]="device/khadas/ohmcas"
uboot_exec_aosp[9]="./mk sc2_ah232  --vab --avb2"
uboot_exec_drm[9]="./mk sc2_ah232  --vab --avb2"
kernel_exec[9]="./mk ohmcas -v 5.4"
###########################################################################################

###########################################################################################
# AP201
project[10]="AP201"
soc[10]="S905W2"
hardware[10]="AP201"
module[10]="ap201"
uboot_path[10]="device/khadas/ap201"
uboot_exec_aosp[10]="./mk s4_ap201  --vab --avb2"
uboot_exec_drm[10]="./mk s4_ap201  --vab --avb2"
kernel_exec[10]="./mk ap201 -v 5.4"
###########################################################################################

###########################################################################################
# OHM MXL258C
project[11]="Ohm-mxl258c"
soc[11]="S905X4"
hardware[11]="AH212"
module[11]="ohm_mxl258c"
uboot_path[11]="device/khadas/ohm"
uboot_exec_aosp[11]="./mk sc2_ah212  --vab --avb2"
uboot_exec_drm[11]="./mk sc2_ah212  --vab --avb2"
kernel_exec[11]="./mk ohm -v 5.4 --fccpip"
###########################################################################################

###########################################################################################
# Smith
project[12]="Smith"
soc[12]="T965D4"
hardware[12]="AR321"
module[12]="smith"
uboot_path[12]="device/khadas/smith"
uboot_exec_aosp[12]="./mk t3_t965d4  --vab"
uboot_exec_drm[12]="./mk t3_t965d4  --vab --avb2"
kernel_exec[12]="./mk smith -v 5.4"
###########################################################################################

###########################################################################################
# T982_AR301
project[13]="T982_AR301"
soc[13]="T982"
hardware[13]="AR301"
module[13]="t982_ar301"
uboot_path[13]="device/khadas/t982_ar301"
uboot_exec_aosp[13]="./mk t3_t982  --vab"
uboot_exec_drm[13]="./mk t3_t982  --vab"
kernel_exec[13]="./mk t982_ar301 -v 5.4"
###########################################################################################

###########################################################################################
# OPPENCAS
project[14]="Oppencas"
soc[14]="S905C3"
hardware[14]="AP232"
module[14]="oppencas"
uboot_path[14]="device/khadas/oppencas"
uboot_exec_aosp[14]="./mk s4_ap232  --vab --avb2"
uboot_exec_drm[14]="./mk s4_ap232  --vab --avb2"
kernel_exec[14]="./mk oppencas -v 5.4"
###########################################################################################

###########################################################################################
# OPPENCAS MXL258C
project[15]="Oppencas_mxl258c"
soc[15]="S905C3"
hardware[15]="AP232"
module[15]="oppencas_mxl258c"
uboot_path[15]="device/khadas/oppencas"
uboot_exec_aosp[15]="./mk s4_ap232  --vab --avb2"
uboot_exec_drm[15]="./mk s4_ap232  --vab --avb2"
kernel_exec[15]="./mk oppencas -v 5.4 --fccpip"
###########################################################################################

###########################################################################################
# Franklin_Hybrid
project[16]="Franklin_Hybrid"
soc[16]="S905X2"
hardware[16]="U215"
module[16]="franklin_hybrid"
uboot_path[16]="device/khadas/franklin/franklin_hybrid"
uboot_exec_aosp[16]="./mk g12a_u215_v1  --vab --avb2"
uboot_exec_drm[16]="./mk g12a_u215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[16]="./mk franklin -v 4.9"
###########################################################################################

###########################################################################################
# Soddy
project[17]="Soddy"
soc[17]="T962D4"
hardware[17]="AT301"
module[17]="soddy"
uboot_path[17]="device/khadas/soddy"
uboot_exec_aosp[17]="./mk t5w_at301_v1  --vab"
uboot_exec_drm[17]="./mk t5w_at301_v1  --vab --avb2"
kernel_exec[17]="./mk soddy -v 5.4"
###########################################################################################

###########################################################################################
# AP223
project[18]="OPPEN"
soc[18]="S905Y4"
hardware[18]="AP223"
module[18]="oppen"
uboot_path[18]="device/khadas/oppen"
uboot_exec_aosp[18]="./mk s4_ap223  --vab --avb2"
uboot_exec_drm[18]="./mk s4_ap223  --vab --avb2"
kernel_exec[18]="./mk oppen -v 5.4"
###########################################################################################

###########################################################################################
# A311D2 32bit
project[19]="kvim4"
soc[19]="A311D2"
hardware[19]="A311D2-AN400"
module[19]="kvim4"
uboot_path[19]="device/khadas/kvim4"
uboot_exec_aosp[19]="./mk kvim4_lpddr4x --avb2 --vab"
uboot_exec_drm[19]="./mk kvim4_lpddr4x --bl32 bl32_3.8/bin/t7/a311d2/blob-bl32.bin.signed --vab"
kernel_exec[19]="./mk kvim4 -v 5.4"
###########################################################################################

usage() {
    echo -e \
    "Usage: Build Android image or sub-modules.\n" \
    "       1. No Params: build android image(through select platform and android).\n" \
    "       1. 1  Params: build android sub-image(through select platform and android).\n" \
    "             params: uboot\n" \
    "                     all-uboot\n" \
    "                     bootimage\n" \
    "                     vendorimage\n" \
    "                     vendorbootimage\n" \
    "                     logoimage\n" \
    "                     odmimage\n" \
    "                     odmextimage\n" \
    "                     systemimage\n" \
    "                     systemextimage\n" \
    "       2. 3  Params: [project-name][android-type][user/userdebug].\n" \
    "                  ./xxxx.sh ohm GTVS userdebug.\n" \

}

########################################################################################################################################################################
# Read Platform config
# Through the input number, to get project-name/project-path/uboot-params
# uboot-params : how to build uboot.
# project-path : how to replace the newest uboot.
# project-name : how to build the code.
########################################################################################################################################################################
read_platform_type() {
    # compile all uboot, no need select platform.
    if [[ $params == "all-uboot" ]]; then
        return
    fi
    while true :
    do
        printf "[%3s]   [%15s]   [%15s]  [%15s]\n" "NUM" "PROJECT" "SOC TYPE" "HARDWARE TYPE"
        echo "-----------------------------------------------------------------"
        for i in `seq ${#project[@]}`;do
            printf "[%3d]   [%15s]  [%15s]  [%15s]\n" $i ${project[i]} ${soc[i]} ${hardware[i]}
        done

        echo "-----------------------------------------------------------------"
        read -p "Please input platform NUM ([1 ~ ${#project[@]}], default 1 ):" platform_type

        if [ ${#platform_type} -eq 0 ]; then
            platform_type=1
            break
        fi

        if [[ $platform_type -lt 1 || $platform_type -gt ${#project[@]} ]]; then
            echo -e "\nError: The platform NUM is illegal!!! Need input again [1 ~ ${#project[@]}]\n"
            echo -e "Please click Enter to continue"
            read
        else
            break
        fi
    done
    echo "Input NUM is [${platform_type}], [${module[platform_type]}]"
}

########################################################################################################################################################################
# Get Android Type: AOSP/DRM/GTVS
########################################################################################################################################################################
read_android_type() {
    while true :
    do
        echo -e \
        "Select compile Android verion type lists:\n"\
        "[NUM]   [Android Version]\n" \
        "[  1]   [AOSP]\n" \
        "[  2]   [DRM ]\n" \
        "[  3]   [GTVS](need google gms zip)\n" \
        "--------------------------------------------\n"

        if [ -d "vendor/google_gtvs" ];then
            default=3
        else
            default=2
        fi
        read -p "Please input Android Version (default $default):" uboot_drm_type
        if [ ${#uboot_drm_type} -eq 0 ]; then
            uboot_drm_type=$default
            break
        fi
        if [[ $uboot_drm_type -lt 1 || $uboot_drm_type -gt 3 ]];then
            echo -e "\nError: The Android Version is illegal, please Input again [1 ~ 3]}\n"
            echo -e "Please click Enter to continue"
            read
        else
            break
        fi
    done
}

########################################################################################################################################################################
#
# Compile Uboot throuth params
# if no params compile userdebug
########################################################################################################################################################################
compile_uboot() {
    cd bootloader/uboot-repo

    if [ $uboot_drm_type -eq 1 ]; then
        echo "${uboot_exec_aosp[platform_type]}"
        ${uboot_exec_aosp[platform_type]}
    else
        echo "${uboot_exec_drm[platform_type]}"
        ${uboot_exec_drm[platform_type]}
    fi
    if [ $? != 0 ]; then echo " Error : Build Uboot error, exit!!!"; exit; fi

    if [ -f "build/u-boot.bin.signed" ];then
        cp build/u-boot.bin.signed ../../${uboot_path[platform_type]}/bootloader.img
        cp build/u-boot.bin.usb.signed ../../${uboot_path[platform_type]}/upgrade/
        cp build/u-boot.bin.sd.bin.signed ../../${uboot_path[platform_type]}/upgrade/
    else
        cp build/u-boot.bin ../../${uboot_path[platform_type]}/bootloader.img;
        cp build/u-boot.bin.usb.bl2 ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.usb.bl2;
        cp build/u-boot.bin.usb.tpl ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.usb.tpl;
        cp build/u-boot.bin.sd.bin ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.sd.bin;
    fi
    cd ../../
}
print_uboot_info() {
    echo -e "\n\ndevice: update uboot [1/1]\n"
    echo -e "PD#SWPL-19355\n"
    echo -e "Problem:"
    echo -e "source code update, need update bootloader\n"
    echo "Solution:"
    cd bootloader/uboot-repo/bl2/bin/
    echo "bl2       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl30/bin/
    echo "bl30      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl30/src_ao/
    echo "bl30 src  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl31/bin/
    echo "bl31      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl31_1.3/bin/
    echo "bl31_1.3  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl32_3.8/bin/
    echo "bl32_3.8  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl33/v2015
    echo "bl33      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl33/v2019
    echo "bl33_v2019: "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/fip/
    echo "fip       : "$(git log --pretty=format:"%H" -1); cd ../../../
    cd vendor/amlogic/common/tdk/
    echo "tdk       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd vendor/amlogic/common/tdk_v3/
    echo "tdk_v3    : "$(git log --pretty=format:"%H" -1); cd ../../../../
    echo -e;
    echo "Verify:"; echo "no need verify"
}

lunch_env() {
    usermode="userdebug"
    if [ $# -eq 1 ]; then usermode="$1"; fi
    source build/envsetup.sh
    # DRM
    if [ $uboot_drm_type -eq 2 ]; then
        export  BOARD_COMPILE_ATV=false
        export  BOARD_COMPILE_CTS=true
    # GTVS
    elif [ $uboot_drm_type -eq 3 ]; then
        if [ ! -d "vendor/google_gtvs" ];then
            echo "==========================================="
            echo "There is not Google GMS in vendor directory"
            echo "==========================================="
            exit
        fi
        export  BOARD_COMPILE_ATV=true
    # AOSP
    else
        export  BOARD_COMPILE_ATV=false
    fi

    ${kernel_addr[platform_type]}
    lunch "${module[platform_type]}-${usermode}"
}

compile_kernel() {
    usermode="userdebug"
    ${kernel_addr[platform_type]}
    if [ $# -eq 1 ]; then usermode="$1"; fi
    echo "${kernel_exec[platform_type]} -t ${usermode}"
    ${kernel_exec[platform_type]} -t ${usermode}
    if [ $? != 0 ]; then echo " Error : Build Kernel error, exit!!!"; exit; fi
}

compile_sub_uboot() {
    params=$1
    if [[ $params == "uboot" ]]; then
        compile_uboot
        print_uboot_info
        exit
    elif [[ $params == "all-uboot" ]]; then
        for platform_type in `seq ${#project[@]}`;do
            compile_uboot
        done
        print_uboot_info
        exit
    fi
    exit
}

compile_sub_system() {
    echo $1
    lunch_env
    if [[ $1 == "bootimage" || $1 == "vendorbootimage" ]]; then
        compile_kernel
        make bootimage -j8
        make vendorbootimage
    elif [ $1 == "logoimage" ]; then
        make logoimg -j8
    elif [ $1 == "odmimage" ]; then
        make odmimage -j8
    elif [ $1 == "odmextimage" ]; then
        make odm_ext_image -j8
    elif [ $1 == "productimage" ]; then
        make productimage -j8
    elif [ $1 == "vendorimage" ]; then
        make vendorimage -j8
    elif [ $1 == "systemimage" ]; then
        make systemimage -j8
    elif [ $1 == "systemextimage" ]; then
        make systemextimage -j8
    fi
    exit
}
########################################################################################################################################################################
# Main Function
########################################################################################################################################################################
if [[ $# -eq 1 && $1 == *"help"* ]] || [ $# -eq 2 ] || [ $# -gt 3 ]; then
    usage
    exit
fi
# Select and build all image.
if [ $# -eq 0 ]; then
    read_platform_type
    read_android_type
    compile_uboot
    compile_kernel
    lunch_env
    make otapackage ${android_exec[platform_type]} -j8
fi

if [ $# -eq 1 ]; then
    read_platform_type
    read_android_type
    if [[ $1 == *"uboot"* ]]; then
        compile_sub_uboot $1
    fi
    compile_sub_system $1
fi

if [ $# -eq 3 ]; then
    if [ -d "vendor/google_gtvs" ];then
        default=3
    else
        default=2
    fi
    uboot_drm_type=$default
    platform_type=0
    usermode="userdebug"
    shopt -s nocasematch
    if [[ $@ == *"userdebug"* ]]; then
        usermode="userdebug"
    elif [[ $@ == *"user"* ]]; then
        usermode="user"
    else
        echo -e "please add params:user/userdebug\n"
        exit
    fi
    if [[ $@ == *"GTVS"* ]]; then
        uboot_drm_type=3
    elif [[ $@ == *"DRM"* ]]; then
        uboot_drm_type=2
    elif [[ $@ == *"AOSP"* ]]; then
        uboot_drm_type=1
    else
        echo -e "please add params:AOSP/DRM/GTVS\n"
        exit
    fi
    for i in "${!module[@]}"
    do
        if [[ $1 == "${module[i]}" || $2 == "${module[i]}" || $3 == "${module[i]}" ]]; then
            platform_type=$i
            break
        fi
    done
    if [[ $platform_type == 0 ]]; then
        echo -e "please add params:platform like ohm/oppen/redi\n"
    fi
    echo $platform_type $uboot_drm_type $usermode
    compile_uboot
    compile_kernel $usermode
    lunch_env $usermode
    make otapackage ${android_exec[platform_type]} -j8
fi
########################################################################################################################################################################
