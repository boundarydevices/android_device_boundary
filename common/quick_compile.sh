#! /bin/bash

#Project Name                  SOC Name                    Hardware Name          device/amlogic project name     uboot compile params           tdk path
project[1]="Ampere"        ;soc[1]="S905X"          ;hardware[1]="P212/P215"    ; module[1]="ampere"        ;uboot[1]="gxl_p212_v1"          ;tdk[1]="gx/bl32.img"
project[2]="Anning"        ;soc[2]="S805Y"          ;hardware[2]="P244"         ; module[2]="anning"        ;uboot[2]="gxl_p244_v1"          ;tdk[2]="gx/bl32.img"
project[3]="Braun"         ;soc[3]="S905D"          ;hardware[3]="P230"         ; module[3]="braun"         ;uboot[3]="gxl_p230_v1"          ;tdk[3]="gx/bl32.img"
project[4]="Curie"         ;soc[4]="S805X"          ;hardware[4]="P241"         ; module[4]="curie"         ;uboot[4]="gxl_p241_v1"          ;tdk[4]="gx/bl32.img"
project[5]="Faraday"       ;soc[5]="S905Y2"         ;hardware[5]="U223"         ; module[5]="faraday"       ;uboot[5]="g12a_u223_v1"         ;tdk[5]="g12a/bl32.img"
project[6]="Fermi"         ;soc[6]="S905D2/S905D3"  ;hardware[6]="U200/AC200"   ; module[6]="fermi"         ;uboot[6]="g12a_u200_v1"         ;tdk[6]="g12a/bl32.img"
project[7]="Franklin"      ;soc[7]="S905X2/S905X3"  ;hardware[7]="U212/AC213"   ; module[7]="franklin"      ;uboot[7]="g12a_u212_v1"         ;tdk[7]="g12a/bl32.img"
project[8]="Galilei"       ;soc[8]="S922X/S922Z"    ;hardware[8]="W200/W400"    ; module[8]="galilei"       ;uboot[8]="g12b_w400_v1"         ;tdk[8]="g12a/bl32.img"
project[9]="Hertz"         ;soc[9]="S912"           ;hardware[9]="Q201"         ; module[9]="hertz"         ;uboot[9]="gxm_q201_v1"          ;tdk[9]="gx/bl32.img"
project[10]="U202"         ;soc[10]="S905D2/S905D3" ;hardware[10]="U202/AC202"  ; module[10]="u202"         ;uboot[10]="g12a_u202_v1"        ;tdk[10]="g12a/bl32.img"
project[11]="Newton"       ;soc[11]="S905X3"        ;hardware[11]="AC213"       ; module[11]="newton"       ;uboot[11]="sm1_ac213_v1"        ;tdk[11]="g12a/bl32.img"
project[12]="Neumann"      ;soc[12]="S905D3"        ;hardware[12]="AC200"       ; module[12]="neumann"      ;uboot[12]="sm1_ac200_v1"        ;tdk[12]="g12a/bl32.img"
project[13]="P281"         ;soc[13]="S905W"         ;hardware[13]="P281"        ; module[13]="p281"         ;uboot[13]="gxl_p281_v1"         ;tdk[13]="gx/bl32.img"

platform_avb_param=""
platform_type=1
uboot_drm_type=1
project_path="null"
uboot_name="null"
tdk_name="null"

read_platform_type() {
    while true :
    do
        printf "[%3d]   [%15s]   [%15s]  [%15s]\n" "NUM" "PROJECT" "SOC TYPE" "HARDWARE TYPE"
        echo "---------------------------------------------"
        for i in `seq ${#project[@]}`;do
            printf "[%3d]   [%15s]  [%15s]  [%15s]\n" $i ${project[i]} ${soc[i]} ${hardware[i]}
        done

        echo "---------------------------------------------"
        read -p "please select platform type (default 1(Ampere)):" platform_type
        if [ ${#platform_type} -eq 0 ]; then
            platform_type=1
        fi
        if [[ $platform_type -lt 1 || $platform_type -gt ${#project[@]} ]]; then
            echo -e "The platform type is illegal!!! Need select again [1 ~ ${#project[@]}]\n"
        else
            break
        fi
    done
    project_path=${module[platform_type]}
    uboot_name=${uboot[platform_type]}
    tdk_name=${tdk[platform_type]}
}

read_android_type() {
    while true :
    do
        echo -e \
        "Select compile Android verion type lists:\n"\
        "[NUM]   [Android Version]\n" \
        "[  1]   [AOSP]\n" \
        "[  2]   [ DRM]\n" \
        "[  3]   [GTVS](need google gms zip)\n" \
        "--------------------------------------------\n"

        read -p "Please select Android Version (default 1 (AOSP)):" uboot_drm_type
        if [ ${#uboot_drm_type} -eq 0 ]; then
            uboot_drm_type=1
            break
        fi
        if [[ $uboot_drm_type -lt 1 || $uboot_drm_type -gt 3 ]];then
            echo -e "The Android Version is illegal, please select again [1 ~ 3]}\n"
        else
            break
        fi
    done
}

compile_uboot(){
    if [ $uboot_drm_type -gt 1 ]; then
        echo -e "[./mk $uboot_name --bl32 ../../vendor/amlogic/common/tdk/secureos/$tdk_name --systemroot]\n"
        ./mk $uboot_name --bl32 ../../vendor/amlogic/common/tdk/secureos/$tdk_name --systemroot ;
    else
        echo -e "[./mk $uboot_name --systemroot]"
        ./mk $uboot_name --systemroot;
    fi

    cp build/u-boot.bin ../../device/amlogic/$project_path/bootloader.img;
    cp build/u-boot.bin.usb.bl2 ../../device/amlogic/$project_path/upgrade/u-boot.bin.usb.bl2;
    cp build/u-boot.bin.usb.tpl ../../device/amlogic/$project_path/upgrade/u-boot.bin.usb.tpl;
    cp build/u-boot.bin.sd.bin ../../device/amlogic/$project_path/upgrade/u-boot.bin.sd.bin;
}

if [ $# -eq 1 ]; then
    if [ $1 == "uboot" ]; then
        read_platform_type
        read_android_type
        cd bootloader/uboot-repo
        compile_uboot
        cd ../../
        exit
    fi

    if [ $1 == "all" ]; then
        read_android_type
        cd bootloader/uboot-repo
        for platform_type in `seq ${#project[@]}`;do
            project_path=${module[platform_type]}
            uboot_name=${uboot[platform_type]}
            tdk_name=${tdk[platform_type]}
            compile_uboot
        done
        cd ../../
        echo -e "device: update uboot [1/1]\n"
        echo -e "PD#SWPL-919\n"
        echo -e "Problem:"
        echo -e "need update bootloader\n"
        echo "Solution:"
        cd bootloader/uboot-repo/bl2/bin/
        echo "bl2       : "$(git log --pretty=format:"%H" -1); cd ../../../../
        cd bootloader/uboot-repo/bl30/bin/
        echo "bl30      : "$(git log --pretty=format:"%H" -1); cd ../../../../
        cd bootloader/uboot-repo/bl31/bin/
        echo "bl31      : "$(git log --pretty=format:"%H" -1); cd ../../../../
        cd bootloader/uboot-repo/bl31_1.3/bin/
        echo "bl31_1.3  : "$(git log --pretty=format:"%H" -1); cd ../../../../
        cd bootloader/uboot-repo/bl33
        echo "bl33      : "$(git log --pretty=format:"%H" -1); cd ../../../
        cd bootloader/uboot-repo/fip/
        echo "fip       : "$(git log --pretty=format:"%H" -1)
        echo -e; cd ../../../../
        echo "Verify:"; echo "no need verify"
    fi
    exit
fi

read_platform_type
read_android_type
source build/envsetup.sh
if [ $uboot_drm_type -eq 2 ]; then
    export  BOARD_COMPILE_CTS=true
elif [ $uboot_drm_type -eq 3 ]; then
    export  BOARD_COMPILE_ATV=true
fi
lunch "${project_path}-userdebug"
cd bootloader/uboot-repo
compile_uboot
cd ../../
make otapackage -j8


