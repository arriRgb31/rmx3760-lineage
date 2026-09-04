#!/bin/bash
# setup-makefiles.sh - Regenerate vendor/realme/rmx3760/device-vendor.mk
# from proprietary-files.txt + proprietary/ contents. Run as root on device
# (or from a build host with $ANDROID_PRODUCT_OUT set).
set -e
cd "$(dirname "$0")"
python3 - <<'PY'
import os
LIST="proprietary-files.txt"
OUT="device-vendor.mk"
with open(LIST) as f:
    lines=[l.strip() for l in f if l.strip() and not l.startswith("#")]
with open(OUT,"w") as w:
    w.write("# Auto-generated device-vendor.mk for realme RMX3760 -- do not edit\n")
    w.write("# Regenerate with: ./setup-makefiles.sh (run as root)\n")
    w.write("PRODUCT_COPY_FILES += \\\n")
    n=len(lines)
    for i,rel in enumerate(lines):
        path=rel[len("vendor/"):]
        w.write('    vendor/realme/rmx3760/proprietary/%s:$(TARGET_COPY_OUT_VENDOR)/%s%s\n' % (path, path, "" if i==n-1 else " \\"))
    w.write("\n")
print("Regenerated %s (%d blocks)" % (OUT, n))
PY
