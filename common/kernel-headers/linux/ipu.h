/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef __ASM_ARCH_IPU_H__
#define __ASM_ARCH_IPU_H__
#include <linux/types.h>
#include <linux/videodev2.h>
#ifndef __cplusplus
typedef unsigned char bool;
#endif
#define irqreturn_t int
#define dma_addr_t int
#define uint32_t unsigned int
#define uint16_t unsigned short
#define uint8_t unsigned char
#define u32 unsigned int
#define u8 unsigned char
#define __u32 u32
typedef enum {
  IPU_ROTATE_NONE = 0,
  IPU_ROTATE_VERT_FLIP = 1,
  IPU_ROTATE_HORIZ_FLIP = 2,
  IPU_ROTATE_180 = 3,
  IPU_ROTATE_90_RIGHT = 4,
  IPU_ROTATE_90_RIGHT_VFLIP = 5,
  IPU_ROTATE_90_RIGHT_HFLIP = 6,
  IPU_ROTATE_90_LEFT = 7,
} ipu_rotate_mode_t;
typedef enum {
  MED_MOTION = 0,
  LOW_MOTION = 1,
  HIGH_MOTION = 2,
} ipu_motion_sel;
typedef enum {
  DISP0,
  DISP1,
  DISP2,
  DISP3
} display_port_t;
#define fourcc(a,b,c,d) (((__u32) (a) << 0) | ((__u32) (b) << 8) | ((__u32) (c) << 16) | ((__u32) (d) << 24))
#define IPU_PIX_FMT_GPU32_SB_ST fourcc('5', 'P', '4', 'S')
#define IPU_PIX_FMT_GPU32_SB_SRT fourcc('5', 'P', '4', 'R')
#define IPU_PIX_FMT_GPU32_ST fourcc('5', 'I', '4', 'S')
#define IPU_PIX_FMT_GPU32_SRT fourcc('5', 'I', '4', 'R')
#define IPU_PIX_FMT_GPU16_SB_ST fourcc('4', 'P', '8', 'S')
#define IPU_PIX_FMT_GPU16_SB_SRT fourcc('4', 'P', '8', 'R')
#define IPU_PIX_FMT_GPU16_ST fourcc('4', 'I', '8', 'S')
#define IPU_PIX_FMT_GPU16_SRT fourcc('4', 'I', '8', 'R')
#define IPU_PIX_FMT_GENERIC fourcc('I', 'P', 'U', '0')
#define IPU_PIX_FMT_GENERIC_32 fourcc('I', 'P', 'U', '1')
#define IPU_PIX_FMT_GENERIC_16 fourcc('I', 'P', 'U', '2')
#define IPU_PIX_FMT_LVDS666 fourcc('L', 'V', 'D', '6')
#define IPU_PIX_FMT_LVDS888 fourcc('L', 'V', 'D', '8')
#define IPU_PIX_FMT_RGB332 fourcc('R', 'G', 'B', '1')
#define IPU_PIX_FMT_RGB555 fourcc('R', 'G', 'B', 'O')
#define IPU_PIX_FMT_RGB565 fourcc('R', 'G', 'B', 'P')
#define IPU_PIX_FMT_BGRA4444 fourcc('4', '4', '4', '4')
#define IPU_PIX_FMT_BGRA5551 fourcc('5', '5', '5', '1')
#define IPU_PIX_FMT_RGB666 fourcc('R', 'G', 'B', '6')
#define IPU_PIX_FMT_BGR666 fourcc('B', 'G', 'R', '6')
#define IPU_PIX_FMT_BGR24 fourcc('B', 'G', 'R', '3')
#define IPU_PIX_FMT_RGB24 fourcc('R', 'G', 'B', '3')
#define IPU_PIX_FMT_GBR24 fourcc('G', 'B', 'R', '3')
#define IPU_PIX_FMT_BGR32 fourcc('B', 'G', 'R', '4')
#define IPU_PIX_FMT_BGRA32 fourcc('B', 'G', 'R', 'A')
#define IPU_PIX_FMT_RGB32 fourcc('R', 'G', 'B', '4')
#define IPU_PIX_FMT_RGBA32 fourcc('R', 'G', 'B', 'A')
#define IPU_PIX_FMT_ABGR32 fourcc('A', 'B', 'G', 'R')
#define IPU_PIX_FMT_YUYV fourcc('Y', 'U', 'Y', 'V')
#define IPU_PIX_FMT_UYVY fourcc('U', 'Y', 'V', 'Y')
#define IPU_PIX_FMT_YVYU fourcc('Y', 'V', 'Y', 'U')
#define IPU_PIX_FMT_VYUY fourcc('V', 'Y', 'U', 'Y')
#define IPU_PIX_FMT_Y41P fourcc('Y', '4', '1', 'P')
#define IPU_PIX_FMT_YUV444 fourcc('Y', '4', '4', '4')
#define IPU_PIX_FMT_VYU444 fourcc('V', '4', '4', '4')
#define IPU_PIX_FMT_AYUV fourcc('A', 'Y', 'U', 'V')
#define IPU_PIX_FMT_NV12 fourcc('N', 'V', '1', '2')
#define PRE_PIX_FMT_NV21 fourcc('N', 'V', '2', '1')
#define IPU_PIX_FMT_NV16 fourcc('N', 'V', '1', '6')
#define PRE_PIX_FMT_NV61 fourcc('N', 'V', '6', '1')
#define IPU_PIX_FMT_TILED_NV12 fourcc('T', 'N', 'V', 'P')
#define IPU_PIX_FMT_TILED_NV12F fourcc('T', 'N', 'V', 'F')
#define IPU_PIX_FMT_GREY fourcc('G', 'R', 'E', 'Y')
#define IPU_PIX_FMT_YVU410P fourcc('Y', 'V', 'U', '9')
#define IPU_PIX_FMT_YUV410P fourcc('Y', 'U', 'V', '9')
#define IPU_PIX_FMT_YVU420P fourcc('Y', 'V', '1', '2')
#define IPU_PIX_FMT_YUV420P fourcc('I', '4', '2', '0')
#define IPU_PIX_FMT_YUV420P2 fourcc('Y', 'U', '1', '2')
#define IPU_PIX_FMT_YVU422P fourcc('Y', 'V', '1', '6')
#define IPU_PIX_FMT_YUV422P fourcc('4', '2', '2', 'P')
#define IPU_PIX_FMT_YUV444P fourcc('4', '4', '4', 'P')
#define IPU_PIX_FMT_TILED_NV12_MBALIGN (16)
#define TILED_NV12_FRAME_SIZE(w,h) (ALIGN((w) * (h), SZ_4K) + ALIGN((w) * (h) / 2, SZ_4K))
typedef enum {
  RGB_CS,
  YUV_CS,
  NULL_CS
} cs_t;
struct ipu_pos {
  u32 x;
  u32 y;
};
struct ipu_crop {
  struct ipu_pos pos;
  u32 w;
  u32 h;
};
struct ipu_deinterlace {
  bool enable;
  u8 motion;
#define IPU_DEINTERLACE_FIELD_TOP 0
#define IPU_DEINTERLACE_FIELD_BOTTOM 1
#define IPU_DEINTERLACE_FIELD_MASK (IPU_DEINTERLACE_FIELD_TOP | IPU_DEINTERLACE_FIELD_BOTTOM)
#define IPU_DEINTERLACE_RATE_EN 0x80
#define IPU_DEINTERLACE_RATE_FRAME1 0x40
#define IPU_DEINTERLACE_RATE_MASK (IPU_DEINTERLACE_RATE_EN | IPU_DEINTERLACE_RATE_FRAME1)
#define IPU_DEINTERLACE_MAX_FRAME 2
  u8 field_fmt;
};
struct ipu_input {
  u32 width;
  u32 height;
  u32 format;
  struct ipu_crop crop;
  dma_addr_t paddr;
  struct ipu_deinterlace deinterlace;
  dma_addr_t paddr_n;
};
struct ipu_alpha {
#define IPU_ALPHA_MODE_GLOBAL 0
#define IPU_ALPHA_MODE_LOCAL 1
  u8 mode;
  u8 gvalue;
  dma_addr_t loc_alp_paddr;
};
struct ipu_colorkey {
  bool enable;
  u32 value;
};
struct ipu_overlay {
  u32 width;
  u32 height;
  u32 format;
  struct ipu_crop crop;
  struct ipu_alpha alpha;
  struct ipu_colorkey colorkey;
  dma_addr_t paddr;
};
struct ipu_output {
  u32 width;
  u32 height;
  u32 format;
  u8 rotate;
  struct ipu_crop crop;
  dma_addr_t paddr;
};
struct ipu_task {
  struct ipu_input input;
  struct ipu_output output;
  bool overlay_en;
  struct ipu_overlay overlay;
#define IPU_TASK_PRIORITY_NORMAL 0
#define IPU_TASK_PRIORITY_HIGH 1
  u8 priority;
#define IPU_TASK_ID_ANY 0
#define IPU_TASK_ID_VF 1
#define IPU_TASK_ID_PP 2
#define IPU_TASK_ID_MAX 3
  u8 task_id;
  int timeout;
};
enum {
  IPU_CHECK_OK = 0,
  IPU_CHECK_WARN_INPUT_OFFS_NOT8ALIGN = 0x1,
  IPU_CHECK_WARN_OUTPUT_OFFS_NOT8ALIGN = 0x2,
  IPU_CHECK_WARN_OVERLAY_OFFS_NOT8ALIGN = 0x4,
  IPU_CHECK_ERR_MIN,
  IPU_CHECK_ERR_INPUT_CROP,
  IPU_CHECK_ERR_OUTPUT_CROP,
  IPU_CHECK_ERR_OVERLAY_CROP,
  IPU_CHECK_ERR_INPUT_OVER_LIMIT,
  IPU_CHECK_ERR_OV_OUT_NO_FIT,
  IPU_CHECK_ERR_OVERLAY_WITH_VDI,
  IPU_CHECK_ERR_PROC_NO_NEED,
  IPU_CHECK_ERR_SPLIT_INPUTW_OVER,
  IPU_CHECK_ERR_SPLIT_INPUTH_OVER,
  IPU_CHECK_ERR_SPLIT_OUTPUTW_OVER,
  IPU_CHECK_ERR_SPLIT_OUTPUTH_OVER,
  IPU_CHECK_ERR_SPLIT_WITH_ROT,
  IPU_CHECK_ERR_NOT_SUPPORT,
  IPU_CHECK_ERR_NOT16ALIGN,
  IPU_CHECK_ERR_W_DOWNSIZE_OVER,
  IPU_CHECK_ERR_H_DOWNSIZE_OVER,
};
#define IPU_CHECK_TASK _IOWR('I', 0x1, struct ipu_task)
#define IPU_QUEUE_TASK _IOW('I', 0x2, struct ipu_task)
#define IPU_ALLOC _IOWR('I', 0x3, int)
#define IPU_FREE _IOW('I', 0x4, int)
#endif
