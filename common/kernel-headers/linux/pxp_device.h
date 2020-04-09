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
  unsigned int virt_uaddr;
  unsigned int mtype;
};
struct pxp_mem_flush {
  unsigned int handle;
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
#define MEMORY_TYPE_UNCACHED 0x0
#define MEMORY_TYPE_WC 0x1
#define MEMORY_TYPE_CACHED 0x2
#define CACHE_CLEAN 0x1
#define CACHE_INVALIDATE 0x2
#define CACHE_FLUSH 0x4
#endif
