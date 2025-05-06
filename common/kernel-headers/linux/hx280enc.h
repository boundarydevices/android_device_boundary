/*
 * This file is auto-generated. Modifications will be lost.
 *
 * See https://android.googlesource.com/platform/bionic/+/master/libc/kernel/
 * for more information.
 */
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
#define HX280ENC_IOCGHWOFFSET _IOR(HX280ENC_IOC_MAGIC, 3, __u32 *)
#define HX280ENC_IOCGHWIOSIZE _IOR(HX280ENC_IOC_MAGIC, 4, __u32 *)
#define HX280ENC_IOC_CLI _IO(HX280ENC_IOC_MAGIC, 5)
#define HX280ENC_IOC_STI _IO(HX280ENC_IOC_MAGIC, 6)
#define HX280ENC_IOCXVIRT2BUS _IOWR(HX280ENC_IOC_MAGIC, 7, __u32 *)
#define HX280ENC_IOCHARDRESET _IO(HX280ENC_IOC_MAGIC, 8)
#define HX280ENC_IOCGSRAMOFFSET _IOR(HX280ENC_IOC_MAGIC, 9, __u32 *)
#define HX280ENC_IOCGSRAMEIOSIZE _IOR(HX280ENC_IOC_MAGIC, 10, __u32 *)
#define HX280ENC_IOCH_ENC_RESERVE _IOR(HX280ENC_IOC_MAGIC, 11, __u32 *)
#define HX280ENC_IOCH_ENC_RELEASE _IOR(HX280ENC_IOC_MAGIC, 12, __u32 *)
#define HX280ENC_IOCG_CORE_WAIT _IOR(HX280ENC_IOC_MAGIC, 13, __u32 *)
#define HX280ENC_IOC_WRITE_REGS _IOW(HX280ENC_IOC_MAGIC, 14, struct enc_regs_buffer *)
#define HX280ENC_IOC_READ_REGS _IOR(HX280ENC_IOC_MAGIC, 15, struct enc_regs_buffer *)
#define HX280ENC_IOCG_EN_CORE _IO(HX280ENC_IOC_MAGIC, 16)
#define HX280ENC_IOC_MAXNR 30
#endif
