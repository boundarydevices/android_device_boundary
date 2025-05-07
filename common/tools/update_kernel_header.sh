#!/bin/bash

# usage: cd android_dir & ./common/tools/update_kerenl_header.sh
# if user add imx special user header file, you can use below way to update:
# cd android_dir & touch device/ezurio/common/kernel-headers/linux/new_uapi &
# ./common/tools/update_kerenl_header.sh

bionic_uapi_tool_path="bionic/libc/kernel/tools"
bionic_kernel_header_path="bionic/libc/kernel/uapi/linux"
imx_kernel_header_path="device/ezurio/common/kernel-headers/linux/"
bionic_drm_kernel_header_path="bionic/libc/kernel/uapi/drm"
libdrm_imx_kernel_header_path="vendor/nxp-opensource/libdrm-imx/include/drm"

function prepare_work
{
mkdir -p external/imx_kernel/linux-stable
cp -r vendor/ezurio/kernel_imx/* external/imx_kernel/linux-stable/.
}

function clean_work
{
cd external/kernel-headers
git checkout .
git clean -df
cd ../../
cd bionic
git checkout .
git clean -df
cd ../
rm external/imx_kernel -rf
}

prepare_work

${bionic_uapi_tool_path}/generate_uapi_headers.sh --use-kernel-dir external/imx_kernel/linux-stable
${bionic_uapi_tool_path}/update_all.py

for file in $(ls ${imx_kernel_header_path})
do
    cp ${bionic_kernel_header_path}/$file device/ezurio/common/kernel-headers/linux/.
done

cp ${bionic_drm_kernel_header_path}/imx_drm.h ${libdrm_imx_kernel_header_path}/.

clean_work
