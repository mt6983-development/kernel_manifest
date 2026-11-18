#!/usr/bin/env bash
set -e

echo "================================================="
echo " Kernel Image, DTB & Modules Custom Copy Script"
echo "================================================="
echo ""

# 1. Ask for the source directory (This MUST exist)
read -rp "Enter source directory (where new compiled outputs/modules are): " SRC
if [[ ! -d "$SRC" ]]; then
  echo "Error: Source directory '$SRC' does not exist."
  exit 1
fi

# 2. Ask for the Kernel Image destination directory (Create if it doesn't exist)
read -rp "Enter destination directory for Image / DTBs: " IMG_DST_DIR
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
echo "[*] Processing Kernel Image..."
# Prefer uncompressed Image (GKI standard), fallback to Image.gz
IMG_SRC=$(find "$SRC" -type f \( -name "Image" -o -name "Image.gz" \) | head -n 1)

if [[ -n "$IMG_SRC" ]]; then
    cp -a "$IMG_SRC" "$IMG_DST_DIR/"
    echo " -> SUCCESS: Copied $(basename "$IMG_SRC") to $IMG_DST_DIR/"
else
    echo " -> SKIP: Image / Image.gz not found in source directory '$SRC'."
fi

# Copy DTB / DTBO if present
echo "[*] Processing DTBs and DTBOs..."
find "$SRC" -type f \( -name "*.dtb" -o -name "*.dtbo" \) | while IFS= read -r dt_file; do
    if [[ -n "$dt_file" ]]; then
        cp -a "$dt_file" "$IMG_DST_DIR/"
        echo " -> SUCCESS: Copied $(basename "$dt_file") to $IMG_DST_DIR/"
    fi
done

echo ""
echo "[*] Syncing & Copying .ko Modules to $MOD_DST_DIR..."
declare -A dst_map

# Map all existing .ko files in the specified modules destination directory
while IFS= read -r f; do
  if [[ -n "$f" ]]; then
    dst_map["$(basename "$f")"]="$f"
  fi
done < <(find "$MOD_DST_DIR" -type f -name "*.ko" 2>/dev/null || true)

new_count=0
replaced_count=0

# Iterate over .ko files in the new source directory
while IFS= read -r src_ko; do
  [[ -z "$src_ko" ]] && continue

  name="$(basename "$src_ko")"

  if [[ -n "${dst_map[$name]}" ]]; then
    target_path="${dst_map[$name]}"
    cp -a "$src_ko" "$target_path"
    echo " -> REPLACED: $name at $target_path"
    replaced_count=$((replaced_count + 1))
  else
    target_path="$MOD_DST_DIR/$name"
    cp -a "$src_ko" "$target_path"
    echo " -> COPIED (New): $name to $target_path"
    new_count=$((new_count + 1))
  fi
done < <(find "$SRC" -name "*.ko" 2>/dev/null)

echo ""
echo "================================================="
echo "Done!"
echo "- Modules Replaced: $replaced_count"
echo "- New Modules Copied: $new_count"
echo "================================================="
