# Copyright (C) 2011 Amlogic Inc
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

#
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Set display related config
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.platform.has.mbxuimode=true \
    ro.platform.has.realoutputmode=true \
    ro.platform.need.display.hdmicec=true

#camera max to 720p
PRODUCT_PROPERTY_OVERRIDES +=  \
    #ro.camera.preview.MaxSize=1280x720 \
    #ro.camera.preview.LimitedRate=1280x720x30,640x480x30,320x240x28

#camera max to 1080p
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.camera.preview.MaxSize=1920x1080 \
    ro.camera.preview.LimitedRate=1920x1080x30,1280x720x30,640x480x30,320x240x28 \
    ro.camera.preview.UseMJPEG=1

#for bt auto connect
PRODUCT_PROPERTY_OVERRIDES += \
    ro.autoconnectbt.isneed=false \
    ro.autoconnectbt.macprefix=00:CD:FF \
    ro.autoconnectbt.btclass=50c \
    ro.autoconnectbt.nameprefix=Amlogic_RC
#if wifi Only
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.radio.noril=false

#if need pppoe
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.net.pppoe=true

# Low memory platform
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.config.low_ram=true \
    ro.platform.support.dolbyvision=true

#the prop is used for enable or disable
#DD+/DD force output when HDMI EDID is not supported
#by default,the force output mode is enabled.
#Note,please do not set the prop to true by default
#only for netflix,just disable the feature.so set the prop to true
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.platform.disable.audiorawout=false
#Dolby DD+ decoder option
#this prop to for videoplayer display the DD+/DD icon when playback
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.platform.support.dolby=true

#DTS decoder option
#display dts icon when playback
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.platform.support.dts=true

#DTS-HD support prop
#PRODUCT_PROPERTY_OVERRIDES += \
    #ro.platform.support.dtstrans=true \
#ro.platform.support.dtsmulasset=true
#DTS-HD prop end
# Enable player buildin
PRODUCT_PROPERTY_OVERRIDES +=  \
    media.amplayer.seekkeyframe=true \
    media.amsuperplayer.enable=true \
    media.amplayer.enable-acodecs=ac3,eac3,rm,dts \
    media.amplayer.enable=true \
    media.amsuperplayer.m4aplayer=STAGEFRIGHT_PLAYER \
    media.amsuperplayer.defplayer=PV_PLAYER \
    media.amplayer.thumbnail=true \
    media.amplayer.dsource4local=1 \
    media.amplayer.dropwaitxms=100 \
    media.arm.audio.decoder=ape,flac,dts,ac3,eac3,wma,wmapro,mp3,aac,vorbis,raac,cook,amr,pcm,adpcm,aac_latm,rm \
    media.wfd.use-pcm-audio=false \
    media.wfd.videoresolution-type=1 \
    media.wfd.videoresolution-group=0 \
    media.wfd.videoframerate=24 \
    media.wfd.video-bitrate=2000000 \
    media.html5videowin.enable=1 \
    media.decoder.vfm.defmap=decoder ppmgr deinterlace amvideo \
    media.decoder.vfm.drmmap=decoder amvideo

#add for video boot, 1 means use video boot, others not .
PRODUCT_PROPERTY_OVERRIDES +=  \
    service.bootvideo=0

# Define drm for this device
PRODUCT_PROPERTY_OVERRIDES +=  \
    drm.service.enabled=1

#used forward seek for libplayer
PRODUCT_PROPERTY_OVERRIDES +=  \
    media.libplayer.seek.fwdsearch=1

#fix hls sync
PRODUCT_PROPERTY_OVERRIDES +=  \
    libplayer.livets.softdemux=1 \
    libplayer.netts.recalcpts=1

#map volume
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.audio.mapvalue=0,0,0,0

#By default, primary storage is physical
PRODUCT_PROPERTY_OVERRIDES += \
    #ro.vold.primary_physical=true
#Support storage visible to apps
PRODUCT_PROPERTY_OVERRIDES +=  \
    persist.fw.force_adoptable=true

#use sdcardfs
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.sys.sdcardfs=true

#add livhls,libcurl as default hls
PRODUCT_PROPERTY_OVERRIDES +=  \
    media.libplayer.curlenable=true \
    media.libplayer.modules=vhls_mod,dash_mod,curl_mod,prhls_mod,vm_mod,bluray_mod


#Hdmi In
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.sys.hdmiin.enable=true \
    mbx.hdmiin.switchfull=false \
    mbx.hdmiin.videolayer=false

#adb
PRODUCT_PROPERTY_OVERRIDES +=  \
    service.adb.tcp.port=5555

#enable/disable afbc
PRODUCT_PROPERTY_OVERRIDES +=  \
    osd.afbcd.enable=1 \
    sys.sf.debug.nohwc=true

# enable droidvold
PRODUCT_PROPERTY_OVERRIDES += \
    ro.droidvold.enable=true
