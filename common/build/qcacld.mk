QCACLD_PATH ?= $(ANDROID_BUILD_TOP)/vendor/boundary/qcacld-2.0
QCACLD_OUT  ?= $(TARGET_OUT_INTERMEDIATES)/QCACLD_OBJ

qcacld_build_make_env = -C $(QCACLD_PATH) KERNEL_SRC=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(strip $(KERNEL_CROSS_COMPILE_WRAPPER)) $(CLANG_TO_COMPILE) \
	KCFLAGS="$(KERNEL_CFLAGS)" KAFLAGS="$(KERNEL_AFLAGS)" CONFIG_FORCE_MLO_SUPPORT=y \

qcacld: $(QCACLD_PATH)
	mkdir -p $(QCACLD_OUT) ; \
	if [ ${clean_build} = 1 ]; then \
		rm -fv $(QCACLD_PATH)/wlan.ko $(QCACLD_OUT)/wlan.ko ; \
		$(kernel_build_shell_env) $(MAKE) $(qcacld_build_make_env) clean ; \
	fi ; \
	$(kernel_build_shell_env) $(MAKE) $(qcacld_build_make_env) ; \
	$(kernel_build_shell_env) llvm-strip --strip-debug \
		$(QCACLD_PATH)/wlan.ko -o $(QCACLD_OUT)/wlan.ko
