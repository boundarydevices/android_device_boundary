#!/bin/bash
set -xe
TARGET_FILE=$1
SCRIPTS_DIR=$2

md5sum ${OUT}/{partition-table*,preboot,boot,dtbo,recovery,cache,system,vendor,vbmeta}.img > md5sums.txt
zip ${TARGET_FILE}.zip \
    ${OUT}/{partition-table*,preboot,boot,dtbo,recovery,cache,system,vendor,vbmeta}.img \
    ${SCRIPTS_DIR}/*.* *-frozen-manifest.xml md5sums.txt


