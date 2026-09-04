# Device makefile for realme RMX3760
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, vendor/realme/rmx3760/device-vendor.mk)

PRODUCT_SOONG_NAMESPACES += \
    device/realme/rmx3760 \
    vendor/realme/rmx3760 \
    kernel/realme/ums9230_a15
