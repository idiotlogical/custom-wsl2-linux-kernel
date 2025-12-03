#!/usr/bin/env bash
set -euo pipefail

# Script to enable CONFIG_HFSPLUS_FS in a kernel .config file
# Usage: run from the top of the kernel source tree where `.config` resides.

KCONF=".config"
if [ ! -f "$KCONF" ]; then
  echo "Error: $KCONF not found. Run this from the kernel source directory." >&2
  exit 1
fi

# Prefer using scripts/config if available (safer), otherwise patch the file directly
if [ -x "scripts/config" ]; then
  echo "Using scripts/config to set HFS+ as module..."
  scripts/config --module HFSPLUS_FS || true
  # Make sure defconfig/resolved symbols are updated
  if command -v make >/dev/null 2>&1; then
    make olddefconfig || true
  fi
  echo "HFS+ set via scripts/config. Run 'make' to build or 'make modules' to build modules." 
  exit 0
fi

# Fallback: directly replace or append in .config
if grep -q '^CONFIG_HFSPLUS_FS=' "$KCONF"; then
  sed -i 's/^CONFIG_HFSPLUS_FS=.*/CONFIG_HFSPLUS_FS=m/' "$KCONF"
else
  echo "CONFIG_HFSPLUS_FS=m" >> "$KCONF"
fi

echo "Applied CONFIG_HFSPLUS_FS=m to $KCONF. Run 'make olddefconfig' and then 'make' to build." 
