#!/bin/bash
# setup-makefiles.sh - Regenerate vendor/realme/rmx3760/device-vendor.mk
# from proprietary/ contents + proprietary-files.txt, mapping each partition
# prefix to the correct TARGET_COPY_OUT_* destination.
#
#   vendor/...   -> $(TARGET_COPY_OUT_VENDOR)/...
#   odm/...      -> $(TARGET_COPY_OUT_ODM)/...
#   vendor_dlkm/ -> $(TARGET_COPY_OUT_VENDOR_DLKM)/...
#
# Run from the vendor tree root (no device needed; reads proprietary/).
set -e
cd "$(dirname "$0")"

python3 - <<'PY'
import os
LIST = "proprietary-files.txt"
OUT  = "device-vendor.mk"

DEST = {
    "vendor":       "$(TARGET_COPY_OUT_VENDOR)",
    "odm":          "$(TARGET_COPY_OUT_ODM)",
    "vendor_dlkm":  "$(TARGET_COPY_OUT_VENDOR_DLKM)",
}

def read_list():
    with open(LIST) as f:
        for l in f:
            l = l.strip()
            if l and not l.startswith("#"):
                yield l

entries = list(read_list())
# dedupe preserving order
seen = set(); uniq = []
for e in entries:
    if e not in seen:
        seen.add(e); uniq.append(e)
entries = uniq

lines = []
for rel in entries:
    part = rel.split("/", 1)[0]
    rest = rel.split("/", 1)[1] if "/" in rel else rel
    dst = DEST.get(part)
    if dst is None:
        print("W: skip unknown partition:", rel)
        continue
    src = f"vendor/realme/rmx3760/proprietary/{rel}"
    lines.append(f"    {src}:{dst}/{rest} \\")

with open(OUT, "w") as w:
    w.write("# Auto-generated device-vendor.mk for realme RMX3760 -- do not edit\n")
    w.write("# Regenerate with: ./setup-makefiles.sh\n")
    w.write("PRODUCT_COPY_FILES += \\\n")
    for i, ln in enumerate(lines):
        ln = ln.rstrip(" \\")
        sep = "" if i == len(lines) - 1 else " \\"
        w.write(ln + sep + "\n")
    w.write("\n")

# report partition stats
from collections import Counter
cnt = Counter(e.split("/",1)[0] for e in entries)
print("device-vendor.mk regenerated:", len(lines), "entries")
print("by partition:", dict(cnt))
PY
