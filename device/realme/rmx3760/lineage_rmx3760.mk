# Lineage OS product makefile for realme RMX3760 (UMS9230) Android 15
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/media_products.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_products.mk)

# Demo/updater
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Vendor tree
$(call inherit-product, vendor/realme/rmx3760/device-vendor.mk)

PRODUCT_BRAND := realme
PRODUCT_DEVICE := rmx3760
PRODUCT_MANUFACTURER := realme
PRODUCT_MODEL := RMX3760
PRODUCT_NAME := lineage_rmx3760

# Hardware properties
PRODUCT_HARDWARE_PLATFORM := ums9230

# Fstab to install into vendor_boot ramdisk (first stage)
PRODUCT_COPY_FILES += \
    device/realme/rmx3760/init/fstab.ums9230_hulk:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_mount/fstab.ums9230_hulk \
    device/realme/rmx3760/init/fstab.ums9230_hulk:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.ums9230_hulk

# Init rc scripts
PRODUCT_PACKAGES += \
    init.ums9230_hulk.rc \
    init.ums9230_hulk.usb.rc

# SoC configs
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.ko.mount.point=/vendor/lib/modules \
    ro.hardware=ums9230_hulk

# Camera / sensors / media use sprd
PRODUCT_VENDOR_PROPERTIES += \
    ro.camera.sound.forced=0 \
    persist.vendor.camera.privapp.list=com.android.hardware.camera2

# Vendor security patch level (align with stock A15)
PRODUCT_OTA_ENFORCE_VINTF_MANIFEST := true
