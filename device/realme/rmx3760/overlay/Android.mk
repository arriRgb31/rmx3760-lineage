LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := rmx3760_overlay
LOCAL_IS_RUNTIME_RESOURCE_OVERLAY := true
LOCAL_SDK_VERSION := current
include $(BUILD_PACKAGE)
