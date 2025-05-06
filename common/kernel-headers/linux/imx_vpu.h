/*
 * This file is auto-generated. Modifications will be lost.
 *
 * See https://android.googlesource.com/platform/bionic/+/master/libc/kernel/
 * for more information.
 */
#ifndef _UAPI__LINUX_IMX_VPU_H
#define _UAPI__LINUX_IMX_VPU_H
#include <linux/videodev2.h>
#include <linux/v4l2-controls.h>
#define V4L2_CID_NON_FRAME (V4L2_CID_USER_IMX_BASE)
#define V4L2_CID_DIS_REORDER (V4L2_CID_USER_IMX_BASE + 1)
#define V4L2_CID_ROI_COUNT (V4L2_CID_USER_IMX_BASE + 2)
#define V4L2_CID_ROI (V4L2_CID_USER_IMX_BASE + 3)
#define V4L2_CID_IPCM_COUNT (V4L2_CID_USER_IMX_BASE + 4)
#define V4L2_CID_IPCM (V4L2_CID_USER_IMX_BASE + 5)
#define V4L2_CID_HDR10META (V4L2_CID_USER_IMX_BASE + 6)
#define V4L2_CID_SECUREMODE (V4L2_CID_USER_IMX_BASE + 7)
#define V4L2_CID_SC_ENABLE (V4L2_CID_USER_IMX_BASE + 8)
#define V4L2_MAX_ROI_REGIONS 8
struct v4l2_enc_roi_param {
  struct v4l2_rect rect;
  __u32 enable;
  __s32 qp_delta;
  __u32 reserved[2];
};
struct v4l2_enc_roi_params {
  __u32 num_roi_regions;
  struct v4l2_enc_roi_param roi_params[V4L2_MAX_ROI_REGIONS];
  __u32 config_store;
  __u32 reserved[2];
};
#define V4L2_MAX_IPCM_REGIONS 2
struct v4l2_enc_ipcm_param {
  struct v4l2_rect rect;
  __u32 enable;
  __u32 reserved[2];
};
struct v4l2_enc_ipcm_params {
  __u32 num_ipcm_regions;
  struct v4l2_enc_ipcm_param ipcm_params[V4L2_MAX_IPCM_REGIONS];
  __u32 config_store;
  __u32 reserved[2];
};
struct v4l2_hdr10_meta {
  __u32 hasHdr10Meta;
  __u32 redPrimary[2];
  __u32 greenPrimary[2];
  __u32 bluePrimary[2];
  __u32 whitePoint[2];
  __u32 maxMasteringLuminance;
  __u32 minMasteringLuminance;
  __u32 maxContentLightLevel;
  __u32 maxFrameAverageLightLevel;
};
#define V4L2_DEC_CMD_IMX_BASE (0x08000000)
#define V4L2_DEC_CMD_RESET (V4L2_DEC_CMD_IMX_BASE + 1)
#define V4L2_EVENT_CODEC_ERROR (V4L2_EVENT_PRIVATE_START + 1)
#define V4L2_EVENT_SKIP (V4L2_EVENT_PRIVATE_START + 2)
#define V4L2_EVENT_CROPCHANGE (V4L2_EVENT_PRIVATE_START + 3)
#define V4L2_EVENT_INVALID_OPTION (V4L2_EVENT_PRIVATE_START + 4)
enum {
  UNKONW_WARNING = - 1,
  RIOREGION_NOTALLOW,
  IPCMREGION_NOTALLOW,
  LEVEL_UPDATED,
};
#define V4L2_PIX_FMT_BGR565 v4l2_fourcc('B', 'G', 'R', 'P')
#define V4L2_PIX_FMT_NV12X v4l2_fourcc('N', 'V', 'X', '2')
#define V4L2_PIX_FMT_DTRC v4l2_fourcc('D', 'T', 'R', 'C')
#define V4L2_PIX_FMT_P010 v4l2_fourcc('P', '0', '1', '0')
#define V4L2_PIX_FMT_TILEX v4l2_fourcc('D', 'T', 'R', 'X')
#define V4L2_PIX_FMT_RFC v4l2_fourcc('R', 'F', 'C', '0')
#define V4L2_PIX_FMT_RFCX v4l2_fourcc('R', 'F', 'C', 'X')
#define V4L2_PIX_FMT_411SP v4l2_fourcc('4', '1', 'S', 'P')
#define V4L2_PIX_FMT_AV1 v4l2_fourcc('A', 'V', '1', '0')
#define V4L2_PIX_FMT_AVS v4l2_fourcc('A', 'V', 'S', '0')
#endif
