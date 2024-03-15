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
#ifndef _LINUX_DMABUF_IMX_H
#define _LINUX_DMABUF_IMX_H
#include <linux/types.h>
struct dmabuf_imx_phys_data {
  __u32 dmafd;
  __u64 phys;
};
struct dmabuf_imx_heap_name {
  __u32 dmafd;
  __u8 name[32];
};
#define DMABUF_GET_PHYS _IOWR('M', 32, struct dmabuf_imx_phys_data)
#define DMABUF_GET_HEAP_NAME _IOWR('M', 33, struct dmabuf_imx_heap_name)
#endif
