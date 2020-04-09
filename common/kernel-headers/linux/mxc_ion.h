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
#ifndef _LINUX_MXC_ION_H
#define _LINUX_MXC_ION_H
#include <linux/ioctl.h>
#include <linux/types.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_CMA_HEAP_ID 0
#define ION_CARVEOUT_HEAP_ID 3
struct ion_phys_data {
  ion_user_handle_t handle;
  unsigned long phys;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ion_phys_dma_data {
  unsigned long phys;
  size_t size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int dmafd;
};
struct ion_phys_virt_data {
  unsigned long virt;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned long phys;
  size_t size;
};
#define ION_IOC_PHYS _IOWR(ION_IOC_MAGIC, 8, struct ion_phys_data)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_IOC_PHYS_DMA _IOWR(ION_IOC_MAGIC, 9, struct ion_phys_dma_data)
#define ION_IOC_PHYS_VIRT _IOWR(ION_IOC_MAGIC, 10, struct ion_phys_virt_data)
#endif
