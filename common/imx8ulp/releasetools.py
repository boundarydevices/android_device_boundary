#
# Copyright (C) 2018 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Add extra commands needed for firmwares update during OTA."""

import common

OPTIONS = common.OPTIONS
def FullOTA_InstallEnd(info):
  # copy the vbmeta and dtbo into the package.
  try:
    vbmeta_img = common.GetBootableImage(
        "vbmeta.img", "vbmeta.img", OPTIONS.input_tmp, "VBMETA")
    dtbo_img = common.GetBootableImage(
        "dtbo.img", "dtbo.img", OPTIONS.input_tmp, "DTBO")
  except KeyError:
    print "no vbmeta or dtbo images in target_files; skipping install"
    return
  # copy the vbmeta into the package.
  common.ZipWriteStr(info.output_zip, "vbmeta.img", vbmeta_img.data)

  # emit the script code to trigger the vbmeta updater on the device
  info.script.WriteRawImage("/vbmeta", "vbmeta.img")

  # copy the dtbo into the package.
  common.ZipWriteStr(info.output_zip, "dtbo.img", dtbo_img.data)

  # emit the script code to trigger the dtbo updater on the device
  info.script.WriteRawImage("/dtbo", "dtbo.img")
