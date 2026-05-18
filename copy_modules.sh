#!/usr/bin/env bash
set -e

echo "================================================="
echo " Kernel Modules & Image.gz Custom Copy Script"
echo "================================================="
echo ""

# 1. Ask for the source directory (This MUST exist)
read -rp "Enter source directory (where new compiled modules/Image.gz are): " SRC
if [[ ! -d "$SRC" ]]; then
  echo "Error: Source directory '$SRC' does not exist."
  exit 1
fi

# 2. Ask for the Image.gz destination directory (Create if it doesn't exist)
read -rp "Enter destination directory for Image.gz: " IMG_DST_DIR
if [[ ! -d "$IMG_DST_DIR" ]]; then
  echo "[*] Directory '$IMG_DST_DIR' does not exist. Creating it automatically..."
  mkdir -p "$IMG_DST_DIR"
fi

# 3. Ask for the Modules destination directory (Create if it doesn't exist)
read -rp "Enter destination directory for .ko modules: " MOD_DST_DIR
if [[ ! -d "$MOD_DST_DIR" ]]; then
  echo "[*] Directory '$MOD_DST_DIR' does not exist. Creating it automatically..."
  mkdir -p "$MOD_DST_DIR"
fi

echo ""
echo "[*] Processing Image.gz..."
# Find Image.gz in the source directory
IMG_SRC=$(find "$SRC" -type f -name "Image.gz" | head -n 1)

if [[ -n "$IMG_SRC" ]]; then
    # Copy Image.gz to the specified destination directory
    cp -a "$IMG_SRC" "$IMG_DST_DIR/"
    echo " -> SUCCESS: Copied Image.gz to $IMG_DST_DIR/"
else
    echo " -> SKIP: Image.gz not found in source directory '$SRC'."
fi

echo ""
echo "[*] Syncing & Copying .ko Modules to $MOD_DST_DIR..."
declare -A dst_map

# Map all existing .ko files in the specified modules destination directory
# Using || true to prevent find from failing if dir is completely empty in some weird cases
while IFS= read -r f; do
  if [[ -n "$f" ]]; then
    dst_map["$(basename "$f")"]="$f"
  fi
done < <(find "$MOD_DST_DIR" -type f -name "*.ko" 2>/dev/null || true)

new_count=0
replaced_count=0

# Iterate over .ko files in the new source directory
while IFS= read -r src_ko; do
  # Skip if variable is empty
  [[ -z "$src_ko" ]] && continue 

  name="$(basename "$src_ko")"
  
  if [[ -n "${dst_map[$name]}" ]]; then
    # Replace the existing module at its exact original path in the destination
    target_path="${dst_map[$name]}"
    cp -a "$src_ko" "$target_path"
    echo " -> REPLACED: $name at $target_path"
    # FIXED: Safe arithmetic evaluation for set -e
    replaced_count=$((replaced_count + 1))
  else
    # Module doesn't exist in the destination, so copy it directly into MOD_DST_DIR
    target_path="$MOD_DST_DIR/$name"
    cp -a "$src_ko" "$target_path"
    echo " -> COPIED (New): $name to $target_path"
    # FIXED: Safe arithmetic evaluation for set -e
    new_count=$((new_count + 1))
  fi
done < <(find "$SRC" -name "*.ko" 2>/dev/null)

echo ""
echo "================================================="
echo "Done!"
echo "- Modules Replaced: $replaced_count"
echo "- New Modules Copied: $new_count"
echo "================================================="
