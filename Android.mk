LOCAL_PATH := $(call my-dir)

ifneq ($(filter extra,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))

include $(CLEAR_VARS)

MEP_LIBS := libmepstarterjni.so
MEP_SYMLINKS := $(addprefix $(TARGET_OUT_PRODUCT_APPS)/SomcMediaExtensionProviderStarter/lib/arm64/,$(notdir $(MEP_LIBS)))
$(MEP_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "MEP lib link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf product/lib64/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += \
    $(MEP_SYMLINKS)

endif
