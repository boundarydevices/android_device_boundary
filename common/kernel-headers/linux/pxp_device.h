/*
 * This file is auto-generated. Modifications will be lost.
 *
 * See https://android.googlesource.com/platform/bionic/+/master/libc/kernel/
 * for more information.
 */
#ifndef _UAPI_PXP_DEVICE
#define _UAPI_PXP_DEVICE
#include <linux/pxp_dma.h>
struct pxp_chan_handle {
  unsigned int handle;
  int hist_status;
};
struct pxp_mem_desc {
  unsigned int handle;
  unsigned int size;
  dma_addr_t phys_addr;
  void * virt_uaddr;
  unsigned int mtype;
  __u32 flags;
  __s32 fd;
};
struct pxp_mem_flush {
  unsigned int handle;
  int dmabuf_fd;
  unsigned int type;
};
#define PXP_IOC_MAGIC 'P'
#define PXP_IOC_GET_CHAN _IOR(PXP_IOC_MAGIC, 0, struct pxp_mem_desc)
#define PXP_IOC_PUT_CHAN _IOW(PXP_IOC_MAGIC, 1, struct pxp_mem_desc)
#define PXP_IOC_CONFIG_CHAN _IOW(PXP_IOC_MAGIC, 2, struct pxp_mem_desc)
#define PXP_IOC_START_CHAN _IOW(PXP_IOC_MAGIC, 3, struct pxp_mem_desc)
#define PXP_IOC_GET_PHYMEM _IOWR(PXP_IOC_MAGIC, 4, struct pxp_mem_desc)
#define PXP_IOC_PUT_PHYMEM _IOW(PXP_IOC_MAGIC, 5, struct pxp_mem_desc)
#define PXP_IOC_WAIT4CMPLT _IOWR(PXP_IOC_MAGIC, 6, struct pxp_mem_desc)
#define PXP_IOC_FLUSH_PHYMEM _IOR(PXP_IOC_MAGIC, 7, struct pxp_mem_flush)
#define PXP_IOC_EXPBUF _IOR(PXP_IOC_MAGIC, 8, struct pxp_mem_desc)
#define MEMORY_TYPE_UNCACHED 0x0
#define MEMORY_TYPE_WC 0x1
#define MEMORY_TYPE_CACHED 0x2
#define CACHE_CLEAN 0x1
#define CACHE_INVALIDATE 0x2
#define CACHE_FLUSH 0x4
#endif
