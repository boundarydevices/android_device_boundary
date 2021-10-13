#!/bin/sh
. build/make/core/build_id.mk
sed -i "s/BUILD_ID=.*/BUILD_ID=$BUILD_ID.$(date +%Y%m%d)/" build/make/core/build_id.mk
