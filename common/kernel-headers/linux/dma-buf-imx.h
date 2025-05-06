/*
 * This file is auto-generated. Modifications will be lost.
 *
 * See https://android.googlesource.com/platform/bionic/+/master/libc/kernel/
 * for more information.
 */
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
#define FLUSH_CACHE 0
#define INVALIDATE_CACHE 1
struct dmabuf_imx_sync {
  __u32 dmafd;
  __u32 operation;
};
#define DMABUF_GET_PHYS _IOWR('M', 32, struct dmabuf_imx_phys_data)
#define DMABUF_GET_HEAP_NAME _IOWR('M', 33, struct dmabuf_imx_heap_name)
#define DMABUF_SYNC _IOWR('M', 34, struct dmabuf_imx_sync)
#endif
