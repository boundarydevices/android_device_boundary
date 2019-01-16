#! /bin/bash


platform_avb_param=""
platform_type=1
uboot_drm_type=1
platform_name="null"
platform_uboot_name="null"
platform_tdk_path="null"

read_platform_type() {
    while true :
    do
        echo -e \
        "select platform lists:\n"\
        "       1. ampere    [S905X]\n"   \
        "       2. braun     [S905D]\n"    \
        "       3. curie     [S805X]\n"    \
        "       4. darwin    [T962E]\n"   \
        "       5. einstein  [T962X]\n" \
        "       6. faraday   [S905Y2]\n"  \
        "       7. fermi     [S905D2]\n"    \
        "       8. franklin  [S905X2]\n" \
        "       9. galilei   [S922X]\n"  \
        "       10. hertz    [S912]\n"   \
        "       11. lyell    [T962]\n"   \
        "       12. marconi  [T962X2]\n" \
        "       13. g12b_skt [S922X]\n"\
        "       14. t962_p321    [T962]\n"  \
        "       15. t962x2_skt   [T962x2]\n" \
        "       16. t962x2_t309  [T962X2]\n"\
        "       17. t962x_r314   [T962X]\n" \

        read -p "please select your platform type (default ampere):" platform_type
        if [ ${#platform_type} -eq 0 ]; then
            platform_type=1
        fi
        if [[ $platform_type -le 0 || $platform_type -gt 17 ]]; then
            echo -e "the platform type is illegal, need select again\n"
        else
            break
        fi
    done
}

read_android_type() {
    while true :
    do
        echo -e \
        "select compile Android verion type lists:\n"\
        "----->1. AOSP\n"\
        "----->2. DRM\n" \
        "----->3. GTVS(need google gms zip)\n"
        read -p "please select your uboot type (default aosp):" uboot_drm_type
        if [ ${#uboot_drm_type} -eq 0 ]; then
            uboot_drm_type=1
            break
        fi
        if [[ $uboot_drm_type -lt 1 || $uboot_drm_type -gt 3 ]];then
            echo -e "the uboot type is illegal, please select again\n"
        else
            break
        fi
    done
}



select_platform_type() {
    case $platform_type in
        1)
            platform_name="ampere"
            platform_uboot_name="gxl_p212_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        2)
            platform_name="braun"
            platform_uboot_name="gxl_p230_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        3)
            platform_name="curie"
            platform_uboot_name="gxl_p241_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        4)
            platform_name="darwin"
            platform_uboot_name="txlx_t962e_r321_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/txlx/bl32.img";;
        5)
            platform_name="einstein"
            platform_uboot_name="txlx_t962x_r311_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/txlx/bl32.img";;
        6)
            platform_name="faraday"
            platform_uboot_name="g12a_u221_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/g12a/bl32.img";;
        7)
            platform_name="fermi"
            platform_uboot_name="g12a_u200_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/g12a/bl32.img";;
        8)
            platform_name="franklin"
            platform_uboot_name="g12a_u212_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/g12a/bl32.img";;
        9)
            platform_name="galilei"
            platform_uboot_name="g12b_w400_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/g12a/bl32.img";;
        10)
            platform_name="hertz"
            platform_uboot_name="gxm_q200_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        11)
            platform_name="lyell"
            platform_uboot_name="txl_p321_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        12)
            platform_name="marconi"
            platform_uboot_name="tl1_x301_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/tl1/bl32.img";;
        13)
            platform_name="g12b_skt"
            platform_uboot_name="g12b_skt_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/g12a/bl32.img";;
        14)
            platform_name="t962_p321"
            platform_uboot_name="txl_p321_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/gx/bl32.img";;
        15)
            platform_name="t962x2_skt"
            platform_uboot_name="tl1_skt_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/tl1/bl32.img";;
        16)
            platform_name="t962x2_t309"
            platform_uboot_name="tl1_t309_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/tl1/bl32.img";;
        17)
            platform_name="t962x_r314"
            platform_uboot_name="txlx_t962x_r314_v1"
            platform_tdk_path="vendor/amlogic/common/tdk/secureos/txlx/bl32.img";;
    esac
}

compile_uboot(){
    if [ $uboot_drm_type -gt 1 ]; then
        echo -e "[./mk $platform_uboot_name --bl32 ../../$platform_tdk_path --systemroot $platform_avb_param]\n"
        ./mk $platform_uboot_name --bl32 ../../$platform_tdk_path --systemroot $platform_avb_param;
    else
        echo -e "[./mk $platform_uboot_name --systemroot $platform_avb_param]"
        ./mk $platform_uboot_name --systemroot $platform_avb_param;
    fi

    cp build/u-boot.bin ../../device/amlogic/$platform_name/bootloader.img;
    cp build/u-boot.bin.usb.bl2 ../../device/amlogic/$platform_name/upgrade/u-boot.bin.usb.bl2;
    cp build/u-boot.bin.usb.tpl ../../device/amlogic/$platform_name/upgrade/u-boot.bin.usb.tpl;
    cp build/u-boot.bin.sd.bin ../../device/amlogic/$platform_name/upgrade/u-boot.bin.sd.bin;
}

if [ $# -eq 1 ]; then
    if [ $1 == "uboot" ]; then
        read_platform_type
        read_android_type
        select_platform_type
        cd bootloader/uboot-repo
        compile_uboot
        cd ../../
        exit
    fi

    if [ $1 == "all" ]; then
        read_android_type
        for ((platform_type=1; platform_type < 18; platform_type++))
        do
            select_platform_type
            cd bootloader/uboot-repo
            compile_uboot
            cd ../../
        done
    fi
    exit
fi

read_platform_type
read_android_type
select_platform_type
source build/envsetup.sh
if [ $uboot_drm_type -eq 2 ]; then
    export  BOARD_COMPILE_CTS=true
elif [ $uboot_drm_type -eq 3 ]; then
    export  BOARD_COMPILE_ATV=true
fi
lunch "$platform_name-userdebug"
cd bootloader/uboot-repo
compile_uboot
cd ../../
make otapackage -j8


