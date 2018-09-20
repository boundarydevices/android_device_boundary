# Copyright (C) 2012 The Android Open Source Project
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

"""Emit extra commands needed for Group during OTA installation
(installing the bootloader)."""

import os
import sys
import shutil
import tempfile
import struct
import common
import sparse_img
import add_img_to_target_files

OPTIONS = common.OPTIONS
OPTIONS.ota_zip_check = True

def SetBootloaderEnv(script, name, val):
  """Set bootloader env name with val."""
  script.AppendExtra('set_bootloader_env("%s", "%s");' % (name, val))

def LoadInfoDict_amlogic(info_dict, input_file, input_dir=None):
  """Read and parse the META/misc_info.txt key/value pairs from the
  input target files and return a dict."""

  data = input_file.read("VENDOR/build.prop")
  data += input_file.read("VENDOR/default.prop")

  info_dict["vendor.prop"] = common.LoadDictionaryFromLines(data.split("\n"))

  print("--- *************** ---")
  common.DumpInfoDict(info_dict)

  return True

def GetBuildProp(prop, info_dict):
  """Return the fingerprint of the build of a given target-files info_dict."""
  try:
    return info_dict.get("build.prop", {})[prop]
  except KeyError:
    print "couldn't find %s in build.prop, try vendor.prop" %(prop)
    #raise common.ExternalError("couldn't find %s in build.prop" % (prop,))

  try:
    return info_dict.get("vendor.prop", {})[prop]
  except KeyError:
    raise common.ExternalError("couldn't find %s in build.prop & vendor.prop" % (prop,))

def HasTargetImage(target_files_zip, image_path):
  try:
    target_files_zip.getinfo(image_path)
    return True
  except KeyError:
    return False

def BuildExt4(name, input_dir, info_dict, block_list=None):
  """Build the (sparse) vendor image and return the name of a temp
  file containing it."""
  return add_img_to_target_files.CreateImage(input_dir, info_dict, name, block_list=block_list)

def ZipOtherImage(which, tmpdir, output):
  """Returns an image object from IMAGES.

  'which' partition eg "logo", "dtb". A prebuilt image and file
  map must already exist in tmpdir.
  """

  amlogic_img_path = os.path.join(tmpdir, "IMAGES", which + ".img")
  if os.path.exists(amlogic_img_path):
    f = open(amlogic_img_path, "rb")
    data = f.read()
    f.close()
    common.ZipWriteStr(output, which + ".img", data)

def GetImage(which, tmpdir):
  """Returns an image object suitable for passing to BlockImageDiff.

  'which' partition must be "system" or "vendor". A prebuilt image and file
  map must already exist in tmpdir.
  """

  assert which in ("system", "vendor", "odm", "product")

  path = os.path.join(tmpdir, "IMAGES", which + ".img")
  mappath = os.path.join(tmpdir, "IMAGES", which + ".map")

  # The image and map files must have been created prior to calling
  # ota_from_target_files.py (since LMP).
  assert os.path.exists(path) and os.path.exists(mappath)

  # Bug: http://b/20939131
  # In ext4 filesystems, block 0 might be changed even being mounted
  # R/O. We add it to clobbered_blocks so that it will be written to the
  # target unconditionally. Note that they are still part of care_map.
  clobbered_blocks = "0"

  return sparse_img.SparseImage(path, mappath, clobbered_blocks)

def mycopyfile(srcfile, dstfile):
    if not os.path.isfile(srcfile):
        print "%s not exist!" %(srcfile)
    else:
        fpath,fname=os.path.split(dstfile)
        if not os.path.exists(fpath):
            os.makedirs(fpath)
        shutil.copyfile(srcfile,dstfile)
        print "copy %s -> %s" %( srcfile,dstfile)


def HasOdmPartition(target_files_zip):
  try:
    target_files_zip.getinfo("ODM/")
    return True
  except KeyError:
    return False

def BuildCustomerImage(info):
  print "amlogic extensions:BuildCustomerImage"
  if info.info_dict.get("update_user_parts") == "true" :
    partsList = info.info_dict.get("user_parts_list");
    for list_i in partsList.split(' '):
      tmp_tgt = GetImage(list_i, info.input_tmp, info.info_dict)
      tmp_tgt.ResetFileMap()
      tmp_diff = common.BlockDifference(list_i, tmp_tgt, src = None)
      tmp_diff.WriteScript(info.script,info.output_zip)

def BuildCustomerIncrementalImage(info, *par, **dictarg):
  print "amlogic extensions:BuildCustomerIncrementalImage"
  fun = []
  for pp in par:
    fun.append(pp)
  if info.info_dict.get("update_user_parts") == "true" :
    partsList = info.info_dict.get("user_parts_list");
    for list_i in partsList.split(' '):
      if HasTargetImage(info.source_zip, list_i.upper() + "/"):
        tmp_diff = fun[0](list_i, info.source_zip, info.target_zip, info.output_zip)
        recovery_mount_options = common.OPTIONS.info_dict.get("recovery_mount_options")
        info.script.Mount("/"+list_i, recovery_mount_options)
        so_far = tmp_diff.EmitVerification(info.script)
        size = []
        if tmp_diff.patch_list:
          size.append(tmp_diff.largest_source_size)
        tmp_diff.RemoveUnneededFiles(info.script)
        total_patch_size = 1.0 + tmp_diff.TotalPatchSize()
        total_patch_size += tmp_diff.TotalPatchSize()
        tmp_diff.EmitPatches(info.script, total_patch_size, 0)
        tmp_items = fun[1](list_i, "META/" + list_i + "_filesystem_config.txt")

        fun[2](tmp_items, info.target_zip, None)
        temp_script = info.script.MakeTemporary()
        tmp_items.GetMetadata(info.target_zip)
        tmp_items.Get(list_i).SetPermissions(temp_script)
        fun[2](tmp_items, info.source_zip, None)
        if tmp_diff and tmp_diff.verbatim_targets:
          info.script.Print("Unpacking new files...")
          info.script.UnpackPackageDir(list_i, "/" + list_i)

        tmp_diff.EmitRenames(info.script)
        if common.OPTIONS.verify and tmp_diff:
          info.script.Print("Remounting and verifying partition files...")
          info.script.Unmount("/" + list_i)
          info.script.Mount("/" + list_i)
          tmp_diff.EmitExplicitTargetVerification(info.script)


def FullOTA_Assertions(info):
  print "amlogic extensions:FullOTA_Assertions"
  if OPTIONS.ota_zip_check:
    info.script.AppendExtra('if ota_zip_check() == "1" then')
    info.script.AppendExtra('set_bootloader_env("upgrade_step", "3");')
    info.script.AppendExtra('backup_data_cache(dtb, /cache/recovery/);')
    info.script.AppendExtra('write_dtb_image(package_extract_file("dt.img"));')
    info.script.AppendExtra('backup_data_cache(recovery, /cache/recovery/);')
    info.script.WriteRawImage("/recovery", "recovery.img")
    info.script.AppendExtra('reboot_recovery();')
    info.script.AppendExtra('else')

def FullOTA_InstallBegin(info):
  print "amlogic extensions:FullOTA_InstallBegin"
  LoadInfoDict_amlogic(info.info_dict, info.input_zip);
  platform = GetBuildProp("ro.board.platform", info.info_dict)
  print "ro.board.platform: %s" % (platform)
  if "meson3" in platform:
    SetBootloaderEnv(info.script, "upgrade_step", "0")
  elif "meson6" in platform:
    SetBootloaderEnv(info.script, "upgrade_step", "0")
  else:
    SetBootloaderEnv(info.script, "upgrade_step", "3")

def FullOTA_InstallEnd(info):
  print "amlogic extensions:FullOTA_InstallEnd"
  print "******has odm partition********* %s" % (OPTIONS.input_tmp)

  odm_tgt = GetImage("odm", OPTIONS.input_tmp)
  odm_tgt.ResetFileMap()
  odm_diff = common.BlockDifference("odm", odm_tgt)
  odm_diff.WriteScript(info.script, info.output_zip)

  product_tgt = GetImage("product", OPTIONS.input_tmp)
  product_tgt.ResetFileMap()
  product_diff = common.BlockDifference("product", product_tgt)
  product_diff.WriteScript(info.script, info.output_zip)

  ZipOtherImage("logo", OPTIONS.input_tmp, info.output_zip)
  ZipOtherImage("dt", OPTIONS.input_tmp, info.output_zip)
  #ZipOtherImage("bootloader", OPTIONS.input_tmp, info.output_zip)
  ZipOtherImage("vbmeta", OPTIONS.input_tmp, info.output_zip)
  if not OPTIONS.two_step:
    ZipOtherImage("recovery", OPTIONS.input_tmp, info.output_zip)

  info.script.AppendExtra("""ui_print("update logo.img...");
package_extract_file("logo.img", "/dev/block/logo");
ui_print("update dtb.img...");
backup_data_cache(dtb, /cache/recovery/);
write_dtb_image(package_extract_file("dt.img"));
ui_print("update recovery.img...");
backup_data_cache(recovery, /cache/recovery/);
package_extract_file("recovery.img", "/dev/block/recovery");
ui_print("update vbmeta.img...");
package_extract_file("vbmeta.img", "/dev/block/vbmeta");""")

  try:
    bootloader_img = info.input_zip.read("RADIO/bootloader.img")
  except KeyError:
    print "no bootloader.img in target_files; skipping install"
  else:
    common.ZipWriteStr(info.output_zip, "bootloader.img", bootloader_img)
    info.script.AppendExtra('ui_print("update bootloader.img...");')
    info.script.AppendExtra('write_bootloader_image(package_extract_file("bootloader.img"));')

  info.script.AppendExtra('if get_update_stage() == "2" then')
  info.script.FormatPartition("/data")
  info.script.FormatPartition("/metadata")
  info.script.AppendExtra('wipe_cache();')
  info.script.AppendExtra('set_update_stage("0");')
  info.script.AppendExtra('endif;')

  info.script.FormatPartition("/param")
  SetBootloaderEnv(info.script, "upgrade_step", "1")
  SetBootloaderEnv(info.script, "force_auto_update", "false")

  if OPTIONS.ota_zip_check:
    info.script.AppendExtra('endif;')


def IncrementalOTA_VerifyBegin(info):
  print "amlogic extensions:IncrementalOTA_VerifyBegin"

def IncrementalOTA_VerifyEnd(info):
  print "amlogic extensions:IncrementalOTA_VerifyEnd"

def IncrementalOTA_InstallBegin(info):
  LoadInfoDict_amlogic(info.info_dict, info.target_zip);
  platform = GetBuildProp("ro.board.platform", info.info_dict)
  print "ro.board.platform: %s" % (platform)
  if "meson3" in platform:
    SetBootloaderEnv(info.script, "upgrade_step", "0")
  elif "meson6" in platform:
    SetBootloaderEnv(info.script, "upgrade_step", "0")
  else:
    SetBootloaderEnv(info.script, "upgrade_step", "3")
  print "amlogic extensions:IncrementalOTA_InstallBegin"

def IncrementalOTA_ImageCheck(info, name):
  source_image = False; target_image = False; updating_image = False;

  image_path = name.upper() + "/" + name
  image_name = name + ".img"

  if HasTargetImage(info.source_zip, image_path):
    source_image = common.File(image_name, info.source_zip.read(image_path));

  if HasTargetImage(info.target_zip, image_path):
    target_image = common.File(image_name, info.target_zip.read(image_path));

  if target_image:
    if source_image:
      updating_image = (source_image.data != target_image.data);
    else:
      updating_image = 1;

  if updating_image:
    message_process = "install " + name + " image..."
    info.script.Print(message_process);
    common.ZipWriteStr(info.output_zip, image_name, target_image.data)
    if name == "dtb":
      info.script.WriteDtbImage(image_name)
    else:
      info.script.WriteRawImage("/" + name, image_name)

  if name == "bootloader":
    if updating_image:
      SetBootloaderEnv(info.script, "upgrade_step", "1")
    else:
      SetBootloaderEnv(info.script, "upgrade_step", "2")


def IncrementalOTA_InstallEnd(info):
  print "amlogic extensions:IncrementalOTA_InstallEnd"
  IncrementalOTA_ImageCheck(info, "logo");
  IncrementalOTA_ImageCheck(info, "dtb");
  IncrementalOTA_ImageCheck(info, "bootloader");
