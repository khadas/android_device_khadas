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
import tempfile
import struct
import common
import sparse_img
import add_img_to_target_files

def SetBootloaderEnv(script, name, val):
  """Set bootloader env name with val."""
  script.AppendExtra('set_bootloader_env("%s", "%s");' % (name, val))

def GetBuildProp(prop, info_dict):
  """Return the fingerprint of the build of a given target-files info_dict."""
  try:
    return info_dict.get("build.prop", {})[prop]
  except KeyError:
    raise common.ExternalError("couldn't find %s in build.prop" % (prop,))

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

def GetImage(which, tmpdir, info_dict):
  # Return an image object (suitable for passing to BlockImageDiff)
  # for the 'which' partition (most be "system" or "vendor").  If a
  # prebuilt image and file map are found in tmpdir they are used,
  # otherwise they are reconstructed from the individual files.

  path = os.path.join(tmpdir, "IMAGES", which + ".img")
  mappath = os.path.join(tmpdir, "IMAGES", which + ".map")
  if os.path.exists(path) and os.path.exists(mappath):
    print "using %s.img from target-files" % (which,)
    # This is a 'new' target-files, which already has the image in it.
  else:
    print "building %s.img from target-files" % (which,)
    # This is an 'old' target-files, which does not contain images
    # already built.  Build them.
    mappath = tempfile.mkstemp()[1]
    common.OPTIONS.tempfiles.append(mappath)
    path = BuildExt4(which, tmpdir, info_dict, block_list = mappath)

  return sparse_img.SparseImage(path, mappath)

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

def FullOTA_InstallBegin(info):
  print "amlogic extensions:FullOTA_InstallBegin"
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
  bootloader_img_exist = 0
  try:
    bootloader_img_info = info.input_zip.getinfo("BOOTLOADER/bootloader")
    bootloader_img_exist = 1
    bootloader_img = common.File("bootloader.img", info.input_zip.read("BOOTLOADER/bootloader"));
  except KeyError:
    print 'WARNING: No BOOTLOADER found'

  if bootloader_img_exist:
    common.CheckSize(bootloader_img.data, "bootloader.img", info.info_dict)
    common.ZipWriteStr(info.output_zip, "bootloader.img", bootloader_img.data)
    info.script.WriteBootloaderImage("/bootloader", "bootloader.img")
    SetBootloaderEnv(info.script, "upgrade_step", "1")
  else:
    SetBootloaderEnv(info.script, "upgrade_step", "1")

  SetBootloaderEnv(info.script, "force_auto_update", "false")


def IncrementalOTA_VerifyBegin(info):
  print "amlogic extensions:IncrementalOTA_VerifyBegin"

def IncrementalOTA_VerifyEnd(info):
  print "amlogic extensions:IncrementalOTA_VerifyEnd"

def IncrementalOTA_InstallBegin(info):
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
      if name == "bootloader":
         info.script.WriteBootloaderImage("/" + name, image_name)
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
