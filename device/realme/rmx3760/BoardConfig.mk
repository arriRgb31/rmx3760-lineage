# BoardConfig for realme RMX3760 (Unisoc UMS9230 / qogirl6 / sharkl6)
# Android 15, GKI boot image v4 (boot/vendor_boot/init_boot split), A/B + logical

# ---- Architecture ----
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_SMP := true
TARGET_USES_64_BIT_BINARIES := true

# ---- Unisoc platform ----
BOARD_UNISOC := true
BOARD_VENDOR_PLATFORM := ums9230
BOARD_BOARD_PLATFORM := ums9230
# ro.hardware (from init.ums9230_hulk.rc imports)
TARGET_BOARD_INFO_FILE := device/realme/rmx3760/configs/bootinfo.txt

# ---- Kernel (GKI split, boot image v4) ----
# Prebuilt stock kernel Image (5.15.178-android13-8-g0c749b198e8d-ab40), extracted
# from live boot_a partition. Matches stock vendor_dlkm modules (no rebuild needed).
TARGET_NO_KERNEL := false
TARGET_PREBUILT_KERNEL := device/realme/rmx3760-kernel/Image
BOARD_KERNEL_BINARIES := kernel
BOARD_KERNEL_IMAGE_NAME := Image
# TODO(optional): rebuild from android_kernel_realme_ums9230_a15 to self-host mainline.
# If enabled, set TARGET_KERNEL_SOURCE := kernel/realme/ums9230_a15
TARGET_KERNEL_SOURCE := kernel/realme/ums9230_a15
# cmdline from stock vendor_boot + bootconfig (androidboot.* lives in bootconfig)
BOARD_KERNEL_CMDLINE := console=ttyS1,115200n8 bootconfig
BOARD_BOOTCONFIG := \\
    androidboot.hardware=ums9230_hulk \\
    androidboot.dtbo_idx=15

# Boot image v4 / GKI (kernel-only boot.img; dtb+ramdisk in vendor_boot)
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_USE_LZ4 := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := false
BOARD_INCLUDE_RECOVERY_DTBO := false
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864

# vendor_boot (real vendor ramdisk; dtb packed in here)
BOARD_VENDOR_BOOT_HEADER_VERSION := 4
BOARD_VENDOR_BOOT_IMAGE_NAME := vendor_boot.img
BOARD_PACK_VENDOR_BOOT := true
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 104857600
TARGET_NO_RECOVERY := true

# init_boot (generic ramdisk)
BOARD_INIT_BOOT_IMAGE_NAME := init_boot.img
BOARD_BUILD_INIT_BOOT := true
BOARD_INIT_BOOTIMAGE_PARTITION_SIZE := 8388608

# DTBO / DTB (Unisoc GKI: dtbo_image in dtbo partition; single-dtb dtbo image in vendor_boot)
BOARD_PREBUILT_DTBOIMAGE := device/realme/rmx3760-kernel/dtbo.img
BOARD_DTBOIMG_OUT := $(PRODUCT_OUT)/dtbo.img
BOARD_DTB_IMG := device/realme/rmx3760-kernel/dtb.img
BOARD_DTBOIMAGE_PARTITION_SIZE := 8388608

# ---- A/B partition slots (seamless update) ----
AB_OTA_UPDATER := true
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# ---- Dynamic (super) partitions ----
BOARD_SUPER_PARTITION_SIZE := 8388608000
BOARD_SUPER_PARTITION_GROUPS := realme_dynamic_partitions
BOARD_REALME_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor odm product vendor_dlkm system_dlkm
BOARD_REALME_DYNAMIC_PARTITIONS_SIZE := 8386543616

# ---- File system ----
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_METADATAIMAGE_PARTITION_SIZE := 67108864
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

# ---- AVB ----
BOARD_AVB_ENABLE := true
BOARD_AVB_VBMETA_SYSTEM := system system_ext
BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_PRODUCT := product
BOARD_AVB_VBMETA_ODM := odm
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
BOARD_AVB_ODM_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256

# ---- SELinux ----
BOARD_VENDOR_SEPOLICY_DIRS += device/realme/rmx3760/sepolicy/vendor
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += device/realme/rmx3760/sepolicy/public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += device/realme/rmx3760/sepolicy/private

# ---- USB / bootloader ----
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_PARTITION_SIZE := 742723584

# ---- Vendor blobs layout ----
# Kernel modules ship in vendor_dlkm (stock); the vendor image build picks
# them up via device-vendor.mk from proprietary/vendor_dlkm. No in-tree
# module build needed.
BOARD_VENDOR_KERNEL_MODULES :=
BOARD_VENDOR_RAMDISK_KERNEL_MODULES :=
BOARD_VENDOR_RAMDISK_FRAGMENTS :=
