#!/bin/bash
# Extract proprietary blobs for realme RMX3760 (UMS9230) from the LIVE
# partition on this rooted device (/vendor). Run as root on the target.
#
# Stores files under proprietary/, mirroring the paths in proprietary-files.txt.
# Requires: root (su), busybox/mkdir, cp.
set -e

SRC_VENDOR=/vendor
VENDOR_PATH="$(dirname "$0")/proprietary"

echo "== Preparing $VENDOR_PATH =="
mkdir -p "$VENDOR_PATH"

echo "== Reading proprietary-files.txt =="
FILELIST="$(dirname "$0")/proprietary-files.txt"
if [ ! -f "$FILELIST" ]; then
  echo "E: $FILELIST not found" >&2
  exit 1
fi

count=0
while IFS= read -r rel || [ -n "$rel" ]; do
  [ -z "$rel" ] && continue
  case "$rel" in \#*|"") continue ;;
  esac
  # "vendor/<path>" -> source /vendor/<path>, dest proprietary/vendor/<path>
  src="${SRC_VENDOR}/${rel#vendor/}"
  dst="${VENDOR_PATH}/${rel#vendor/}"
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    # copy only if missing or newer (idempotent)
    if [ ! -f "$dst" ] || [ "$src" -nt "$dst" ]; then
      cp -p "$src" "$dst"
      count=$((count+1))
    fi
  else
    echo "W: missing source: $src"
  fi
done < "$FILELIST"

echo "== Copied $count new/updated files =="
echo "Done."
