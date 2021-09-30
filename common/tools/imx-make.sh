#!/bin/bash
# Stop if a command fail
set -e

# help function, it display the usage of this script.
help() {
cat << EOF
    This script is executed after "source build/envsetup.sh" and "lunch".

    usage:
        `basename $0` <option>

        options:
           -h/--help               display this help info
           -j[<num>]               specify the number of parallel jobs when build the target, the number after -j should be greater than 0
           bootloader              bootloader will be compiled
           kernel                  kernel, include related dts will be compiled
           galcore                 galcore.ko in GPU repo will be compiled
           vvcam                   vvcam.ko, the ISP driver will be compiled
           mxmwifi                 mlan.ko moal.ko, the MXMWifi driver will be compiled
           qcacld                  wlan.ko, the qcacld-2.0 driver will be compiled
           dtboimage               dtbo images will be built out
           bootimage               boot.img will be built out
           vendorbootimage         vendor_boot.img will be built out
           vendorimage             vendor.img will be built out
           -c                      use clean build for kernel, not incremental build


    an example to build the whole system with maximum parallel jobs as below:
        `basename $0` -j


EOF

exit;
}

# handle special args, now it is used to handle the option for make parallel jobs option(-j).
# the number after "-j" is the jobs in parallel, if no number after -j, use the max jobs in parallel.
# kernel now can't be controlled from this script, so by default use the max jobs in parallel to compile.
handle_special_arg()
{
    # options other than -j are all illegal
    local jobs;
    if [ ${1:0:2} = "-j" ]; then
        jobs=${1:2};
        if [ -z ${jobs} ]; then                                                # just -j option provided
            parallel_option="-j";
        else
            if [[ ${jobs} =~ ^[0-9]+$ ]] && [ ${jobs} -gt 0 ]; then           # integer bigger than 0 after -j
                 parallel_option="-j${jobs}";
            else
                echo invalid -j parameter;
                exit;
            fi
        fi
    else
        echo Unknown option: ${1};
        help;
    fi
}

download_prebuilt_bootloader()
{
    UBOOT_CONFIG=${product_path}/UbootKernelBoardConfig.mk
    UBOOT_NAMES=`awk '/TARGET_BOOTLOADER_PREBUILT/{$1=$2=""; print $0}' ${UBOOT_CONFIG}`
    if [ -z "${UBOOT_NAMES}" ]; then
        echo "No U-Boot prebuilt defined for ${TARGET_PRODUCT}"
        exit
    fi
    # create preboot folder if missing
    mkdir -p ${OUT}/preboot
    # remove artifacts if present
    rm -f ${OUT}/preboot/u-boot.*
    # download each prebuilt binary from BD server
    for UBOOT_NAME in ${UBOOT_NAMES}; do
        URL=http://linode.boundarydevices.com/u-boot-images-2020.10/u-boot.${UBOOT_NAME}
        wget -nv -P ${OUT}/preboot $URL
    done
}

# check whether the build product and build mode is selected
if [ -z ${OUT} ] || [ -z ${TARGET_PRODUCT} ]; then
    help;
fi

# global variables
build_bootloader_kernel_flag=0
build_android_flag=0
build_bootloader=""
build_kernel=""
build_kernel_module_flag=0
build_galcore=""
build_vvcam=""
build_mxmwifi=""
build_qcacld=""
build_bootimage=""
build_vendorbootimage=""
build_dtboimage=""
build_vendorimage=""
parallel_option=""
clean_build=0
TOP=`pwd`

# Force the use of toolchains provided by BD
export AARCH64_GCC_CROSS_COMPILE=$TOP/prebuilts/toolchains/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export CLANG_PATH=$TOP/prebuilts/toolchains

product_makefile=`pwd`/`find device -maxdepth 4 -name "${TARGET_PRODUCT}.mk"`;
product_path=${product_makefile%/*}
nxp_git_path=`pwd`/device/boundary
soc_path=${nxp_git_path}/common/imx8m

# process of the arguments
args=( "$@" )
for arg in ${args[*]} ; do
    case ${arg} in
        -h) help;;
        --help) help;;
        -c) clean_build=1;;
        bootloader) build_bootloader_kernel_flag=1;
                    build_bootloader="bootloader";;
        prebuilt-bootloader) download_prebuilt_bootloader; exit;;
        kernel) build_bootloader_kernel_flag=1;
                    build_kernel="${OUT}/kernel";;
        galcore) build_bootloader_kernel_flag=1;
                    build_kernel_module_flag=1;
                    build_galcore="galcore";;
        vvcam) build_bootloader_kernel_flag=1;
                    build_kernel_module_flag=1
                    build_vvcam="vvcam";;
        mxmwifi) build_bootloader_kernel_flag=1;
                    build_kernel_module_flag=1
                    build_mxmwifi="mxmwifi";;
        qcacld) build_bootloader_kernel_flag=1;
                    build_kernel_module_flag=1
                    build_qcacld="qcacld";;
        bootimage) build_bootloader_kernel_flag=1;
                    build_android_flag=1;
                    build_kernel="${OUT}/kernel";
                    build_bootimage="bootimage";;
        vendorbootimage) build_bootloader_kernel_flag=1;
                    build_android_flag=1;
                    build_kernel="${OUT}/kernel";
                    build_vendorbootimage="vendorbootimage";;
        dtboimage) build_bootloader_kernel_flag=1;
                    build_android_flag=1;
                    build_kernel="${OUT}/kernel";
                    build_dtboimage="dtboimage";;
        vendorimage) build_bootloader_kernel_flag=1;
                    build_android_flag=1;
                    build_kernel="${OUT}/kernel";
                    build_vendorimage="vendorimage";;
        *) handle_special_arg ${arg};;
    esac
done

# if bootloader and kernel not in arguments, all need to be made
if [ ${build_bootloader_kernel_flag} -eq 0 ] && [ ${build_android_flag} -eq 0 ]; then
    build_bootloader="bootloader";
    build_kernel="${OUT}/kernel";
    build_android_flag=1
fi

# vvcam.ko need build with kernel each time to make sure "insmod vvcam.ko" works
if [ -n "${build_kernel}" ] && [[ "${TARGET_PRODUCT}" =~ "8mp" ]]; then
    build_vvcam="vvcam";
    build_kernel_module_flag=1;
fi

# wlan.ko need build with kernel each time to make sure "insmod wlan.ko" works
if [ -n "${build_kernel}" ]; then
    build_qcacld="qcacld";
    build_kernel_module_flag=1;
fi

# if uboot is to be compiled, remove the UBOOT_COLLECTION directory
if [ -n "${build_bootloader}" ]; then
    rm -rf ${OUT}/obj/UBOOT_COLLECTION
fi

# redirect standard input to /dev/null to avoid manually input in kernel configuration stage
soc_path=${soc_path} product_path=${product_path} nxp_git_path=${nxp_git_path} clean_build=${clean_build} \
    make -C ./ -f ${nxp_git_path}/common/build/Makefile ${parallel_option} \
    ${build_bootloader} ${build_kernel} </dev/null || exit

if [ ${build_kernel_module_flag} -eq 1 ]; then
    soc_path=${soc_path} product_path=${product_path} nxp_git_path=${nxp_git_path} clean_build=${clean_build} \
        make -C ./ -f ${nxp_git_path}/common/build/Makefile ${parallel_option} \
        ${build_vvcam} ${build_galcore} ${build_qcacld} ${build_mxmwifi} </dev/null || exit
fi

if [ ${build_android_flag} -eq 1 ]; then
    # source envsetup.sh before building Android rootfs, the time spent on building uboot/kernel
    # before this does not count in the final result
    source build/envsetup.sh
    make ${parallel_option} ${build_bootimage} ${build_vendorbootimage} ${build_dtboimage} ${build_vendorimage}
fi

# copy the uboot output to ${OUT_DIR}
if [ -n "${build_bootloader}" ]; then
    cp -f ${OUT}/obj/UBOOT_COLLECTION/*\.* ${OUT}
fi
