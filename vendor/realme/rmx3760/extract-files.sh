#!/bin/bash
# Extract proprietary blobs for realme RMX3760 (UMS9230) from the LIVE
# partitions on this rooted device (/vendor, /odm, /vendor_dlkm).
# Run as root on the target (su).
#
# proprietary-files.txt entries are relative to the partition root, prefixed
# with the partition name, e.g.:
#   vendor/...           -> /vendor/<rest>
#   odm/...              -> /odm/<rest>
#   vendor_dlkm/...      -> /vendor_dlkm/<rest>
#
# Stored under proprietary/<partition>/<rest>, mirroring the paths.
# Requires: root (su), mkdir, cp, dd (for fs_config generation not used here).
set -e

BASE="$(cd "$(dirname "$0")" && pwd)"
VENDOR_PATH="$BASE/proprietary"
FILELIST="$BASE/proprietary-files.txt"

# map partition prefix -> live mount point
declare -A PART_MOUNT=(
  [vendor]="/vendor"
  [odm]="/odm"
  [vendor_dlkm]="/vendor_dlkm"
)

echo "== Preparing $VENDOR_PATH =="
mkdir -p "$VENDOR_PATH"

[ -f "$FILELIST" ] || { echo "E: $FILELIST not found" >&2; exit 1; }

count=0
missing=0
while IFS= read -r rel || [ -n "$rel" ]; do
  rel="${rel#"${rel%%[![:space:]]*}"}"   # ltrim
  rel="${rel%"${rel##*[![:space:]]}"}"   # rtrim
  [ -z "$rel" ] && continue
  case "$rel" in \#*|"") continue ;; esac

  part="${rel%%/*}"
  mp="${PART_MOUNT[$part]:-}"
  if [ -z "$mp" ]; then
    echo "W: unknown partition prefix: $part (skip $rel)"
    continue
  fi
  rest="${rel#*/}"
  src="$mp/$rest"
  dst="$VENDOR_PATH/$part/$rest"

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    if [ ! -f "$dst" ] || [ "$src" -nt "$dst" ]; then
      cp -p "$src" "$dst"
      count=$((count+1))
    fi
  else
    echo "W: missing source: $src"
    missing=$((missing+1))
  fi
done < "$FILELIST"

echo "== Copied $count new/updated files (missing=$missing) =="
echo "Done."
