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
#ifndef _UAPI_HX280ENC_H_
#define _UAPI_HX280ENC_H_
#include <linux/ioctl.h>
#include <linux/types.h>
#undef PDEBUG
#ifdef HX280ENC_DEBUG
#define PDEBUG(fmt,args...) printf(__FILE__ ":%d: " fmt, __LINE__, ##args)
#else
#define PDEBUG(fmt,args...)
#endif
struct enc_regs_buffer {
  __u32 core_id;
  __u32 * regs;
  __u32 offset;
  __u32 size;
  __u32 * reserved;
};
#define HX280ENC_IOC_MAGIC 'k'
#define HX280ENC_IOCGHWOFFSET _IOR(HX280ENC_IOC_MAGIC, 3, unsigned long *)
#define HX280ENC_IOCGHWIOSIZE _IOR(HX280ENC_IOC_MAGIC, 4, unsigned int *)
#define HX280ENC_IOC_CLI _IO(HX280ENC_IOC_MAGIC, 5)
#define HX280ENC_IOC_STI _IO(HX280ENC_IOC_MAGIC, 6)
#define HX280ENC_IOCXVIRT2BUS _IOWR(HX280ENC_IOC_MAGIC, 7, unsigned long *)
#define HX280ENC_IOCHARDRESET _IO(HX280ENC_IOC_MAGIC, 8)
#define HX280ENC_IOCGSRAMOFFSET _IOR(HX280ENC_IOC_MAGIC, 9, unsigned long *)
#define HX280ENC_IOCGSRAMEIOSIZE _IOR(HX280ENC_IOC_MAGIC, 10, unsigned int *)
#define HX280ENC_IOCH_ENC_RESERVE _IOR(HX280ENC_IOC_MAGIC, 11, unsigned int *)
#define HX280ENC_IOCH_ENC_RELEASE _IOR(HX280ENC_IOC_MAGIC, 12, unsigned int *)
#define HX280ENC_IOCG_CORE_WAIT _IOR(HX280ENC_IOC_MAGIC, 13, unsigned int *)
#define HX280ENC_IOC_WRITE_REGS _IOW(HX280ENC_IOC_MAGIC, 14, struct enc_regs_buffer *)
#define HX280ENC_IOC_READ_REGS _IOR(HX280ENC_IOC_MAGIC, 15, struct enc_regs_buffer *)
#define HX280ENC_IOCG_EN_CORE _IO(HX280ENC_IOC_MAGIC, 16)
#define HX280ENC_IOC_MAXNR 30
#endif
