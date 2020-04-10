#!/bin/bash

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
           dtboimage               dtbo images will be built out
           bootimage               boot.img will be built out
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

# check whether the build product and build mode is selected
if [ -z ${OUT} ] || [ -z ${TARGET_PRODUCT} ]; then
    help;
fi

# global variables
build_bootloader_kernel_flag=0
build_android_flag=0
build_bootloader=""
build_kernel=""
build_bootimage=""
build_dtboimage=""
build_vendorimage=""
parallel_option=""
clean_build=0

# process of the arguments
args=( "$@" )
for arg in ${args[*]} ; do
    case ${arg} in
        -h) help;;
        --help) help;;
        -c) clean_build=1;;
        bootloader) build_bootloader_kernel_flag=1;
                    build_bootloader="bootloader";;
        kernel) build_bootloader_kernel_flag=1;
                    build_kernel="${OUT}/kernel";;
        bootimage) build_bootloader_kernel_flag=1;
                    build_android_flag=1;
                    build_kernel="${OUT}/kernel";
                    build_bootimage="bootimage";;
        dtboimage) build_kernel_flag=1;
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

product_makefile=`pwd`/`find device/boundary -maxdepth 4 -name "${TARGET_PRODUCT}.mk"`;
product_path=${product_makefile%/*}
soc_path=${product_path%/*}/common/imx8m
fsl_git_path=${product_path%/*}

# if uboot is to be compiled, remove the UBOOT_COLLECTION directory
if [ -n "${build_bootloader}" ]; then
    rm -rf ${OUT}/obj/UBOOT_COLLECTION
fi

# redirect standard input to /dev/null to avoid manually input in kernel configuration stage
soc_path=${soc_path} product_path=${product_path} fsl_git_path=${fsl_git_path} clean_build=${clean_build} \
    make -C ./ -f ${fsl_git_path}/common/build/Makefile ${parallel_option} \
    ${build_bootloader} ${build_kernel} </dev/null || exit

if [ ${build_android_flag} -eq 1 ]; then
    # source envsetup.sh before building Android rootfs, the time spent on building uboot/kernel
    # before this does not count in the final result
    source build/envsetup.sh
    make ${parallel_option} ${build_bootimage} ${build_dtboimage} ${build_vendorimage}
fi

# copy the uboot output to ${OUT_DIR}
if [ -n "${build_bootloader}" ]; then
    cp -f ${OUT}/obj/UBOOT_COLLECTION/*\.* ${OUT}
fi

