PACKAGE_FIRMWARE_TOOL :=
FIRMWARE_ENCRYPT_KEY_FILE :=

FIRMWARE_BINARY :=
FIRMWARE_BINARY_INTITAL :=
FIRMWARE_MANIFEST :=
FIRMWARE_BINARY_ENCRYPTED :=
FIRMWARE_ENCRYPT_KEY_ID :=
UNSIGNED_APP :=
FIRMWARE_BINARY_SIGNED :=
FIRMWARE_SIGN_KEY_ID :=
FIRMWARE_SIGN_KEY_FILE :=
TOP ?= ./
FSL_RESTRICTED_CODEC_PATH := $(TOP)/vendor/nxp-private/fsl-restricted-codec/fsl_real_dec

ifeq ($(strip $(PACKAGE_FIRMWARE_TOOL)),)
PACKAGE_FIRMWARE_TOOL := $(TOP)/device/nxp/common/tools/package_tool
endif

FIRMWARE_MANIFEST :=  $(TOP)/vendor/nxp/linux-firmware-imx/firmware/vpu/manifest

$(FIRMWARE_MANIFEST):
	@touch $(FIRMWARE_MANIFEST)
	@echo "firmware" > $(FIRMWARE_MANIFEST)

.PHONY: manifest
manifest: $(FIRMWARE_MANIFEST)

ifeq (,$(wildcard $(FSL_RESTRICTED_CODEC_PATH)))
$(info "use linux-imx-firmware")
else
$(info "use restricted-codec firmware")
ifeq ("$(TARGET_PRODUCT)", "mek_8q")
$(shell cp $(FSL_RESTRICTED_CODEC_PATH)/vpu_fw_imx8_dec.bin vendor/nxp/linux-firmware-imx/firmware/vpu/vpu_fw_imx8_dec.bin)
endif
endif

ifeq ("$(TARGET_PRODUCT)", "mek_8q")
FIRMWARE_BINARY := $(TOP)/vendor/nxp/linux-firmware-imx/firmware/vpu/vpu_fw_imx8_dec.bin
else
FIRMWARE_BINARY := $(TOP)/vendor/nxp/linux-firmware-imx/firmware/vpu/wave633c_codec_fw.bin
endif

FIRMWARE_BINARY_INTITAL := $(patsubst %.bin,%.bin.initial,$(FIRMWARE_BINARY))

#build out cbor file
$(FIRMWARE_BINARY_INTITAL): PACKAGE_FIRMWARE_TOOL := $(PACKAGE_FIRMWARE_TOOL)
$(FIRMWARE_BINARY_INTITAL): $(FIRMWARE_BINARY) $(FIRMWARE_MANIFEST) $(PACKAGE_FIRMWARE_TOOL)
	@$(MKDIR)
	@echo building $@ from $<
	@$(PACKAGE_FIRMWARE_TOOL) -m build $@ $< $(word 2,$^)

.PHONY: build
build: $(FIRMWARE_BINARY_INTITAL)

#encrypt cbor file
FIRMWARE_BINARY_ENCRYPTED := $(patsubst %.bin,%.bin.encrypted,$(FIRMWARE_BINARY))
FIRMWARE_ENCRYPT_KEY_FILE :=  $(TOP)/device/nxp/common/security/firmware_encrypt_key.bin
FIRMWARE_ENCRYPT_KEY_ID := 0

$(FIRMWARE_BINARY_ENCRYPTED): PACKAGE_FIRMWARE_TOOL := $(PACKAGE_FIRMWARE_TOOL)
$(FIRMWARE_BINARY_ENCRYPTED): FIRMWARE_ENCRYPT_KEY_FILE := $(FIRMWARE_ENCRYPT_KEY_FILE)
$(FIRMWARE_BINARY_ENCRYPTED): FIRMWARE_ENCRYPT_KEY_ID:= $(FIRMWARE_ENCRYPT_KEY_ID)
$(FIRMWARE_BINARY_ENCRYPTED): $(FIRMWARE_BINARY_INTITAL) $(FIRMWARE_ENCRYPT_KEY_FILE) $(PACKAGE_FIRMWARE_TOOL)
	@$(MKDIR)
	@echo building $@ from $<
	@$(PACKAGE_FIRMWARE_TOOL) -m encrypt $@ $< \
		$(FIRMWARE_ENCRYPT_KEY_FILE) $(FIRMWARE_ENCRYPT_KEY_ID)

UNSIGNED_APP := $(FIRMWARE_BINARY_ENCRYPTED)
.PHONY: encrypt
encrypt: $(FIRMWARE_BINARY_ENCRYPTED)

#sign encrypted file
FIRMWARE_BINARY_SIGNED := $(patsubst %.bin,%.bin.signed,$(FIRMWARE_BINARY))

FIRMWARE_SIGN_KEY_ID := 0
FIRMWARE_SIGN_KEY_FILE :=  $(TOP)/device/nxp/common/security/firmware_private_key.der
$(FIRMWARE_BINARY_SIGNED): PACKAGE_FIRMWARE_TOOL := $(PACKAGE_FIRMWARE_TOOL)
$(FIRMWARE_BINARY_SIGNED): FIRMWARE_SIGN_KEY_FILE := $(FIRMWARE_SIGN_KEY_FILE)
$(FIRMWARE_BINARY_SIGNED): FIRMWARE_SIGN_KEY_ID := $(FIRMWARE_SIGN_KEY_ID)
$(FIRMWARE_BINARY_SIGNED): $(UNSIGNED_APP) $(FIRMWARE_SIGN_KEY_FILE) $(PACKAGE_FIRMWARE_TOOL)
	@$(MKDIR)
	@echo building $@ from $<
	@$(PACKAGE_FIRMWARE_TOOL) -m sign $@ $< \
		$(FIRMWARE_SIGN_KEY_FILE) $(FIRMWARE_SIGN_KEY_ID)

.PHONY: sign
sign: $(FIRMWARE_BINARY_SIGNED)

.PHONY: clean
clean:
	@rm $(FIRMWARE_MANIFEST)
	@rm $(FIRMWARE_BINARY_INTITAL)
	@rm $(FIRMWARE_BINARY_ENCRYPTED)

