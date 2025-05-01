BACKPORTS_PATH ?= $(ANDROID_BUILD_TOP)/vendor/ezurio/backports/backport
BACKPORTS_OUT  ?= $(TARGET_OUT_INTERMEDIATES)/BACKPORTS_OBJ

backports_build_make_env = KLIB_BUILD=$(realpath $(KERNEL_OUT)) ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(strip $(KERNEL_CROSS_COMPILE_WRAPPER)) $(CLANG_TO_COMPILE) \
	KCFLAGS="$(KERNEL_CFLAGS) -Wno-strict-prototypes" KAFLAGS="$(KERNEL_AFLAGS)" -C $(BACKPORTS_PATH)

backports: $(BACKPORTS_PATH)
	if [ ${clean_build} = 1 ]; then \
		rm -rf $(BACKPORTS_OUT) ; \
		$(kernel_build_shell_env) $(MAKE) $(backports_build_make_env) mrproper ; \
	fi ;
	mkdir -p $(BACKPORTS_OUT) ;
	# workaround qcacld needing stdarg.h header
	if [ ! -e $(BACKPORTS_PATH)/drivers/net/wireless/laird/qcacld/CORE/VOSS/inc/stdarg.h ]; then \
		cp -v $(realpath $(TARGET_KERNEL_SRC)/include/linux/stdarg.h) \
			$(BACKPORTS_PATH)/drivers/net/wireless/laird/qcacld/CORE/VOSS/inc/ ; \
	fi ;
	# use custom defconfig for our devices
	if [ ! -e $(BACKPORTS_PATH)/.config ]; then \
		$(kernel_build_shell_env) $(MAKE) $(backports_build_make_env) defconfig-bdimx8 ; \
	fi ;
	$(kernel_build_shell_env) $(MAKE) $(backports_build_make_env)
	$(kernel_build_shell_env) find $(BACKPORTS_PATH) -name "*.ko" -exec \
		llvm-strip --strip-debug {} \;
	find $(BACKPORTS_PATH) -name "*.ko" -exec cp -v {} $(BACKPORTS_OUT) \;
