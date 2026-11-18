<div align="center">
  <h1>⚡ OnePlus Nord 3 (vitamin, MT6983) Kernel Source ⚡</h1>
  <p><strong>Kleaf & Android Common Kernel (ACK) 6.18 Build Manifest</strong></p>
</div>

---

## 🚀 Getting Started

Follow these instructions to initialize your workspace, synchronize the source tree, and compile the kernel using Google Kleaf (Bazel).

### 📦 1. Initialize Workspace
Set up your local repository using the kernel manifest:
```bash
repo init -u https://github.com/mt6983-development/kernel_manifest.git -b main --depth=1
```

### 🔄 2. Sync Source Tree
Fetch all required repositories, toolchains, and Kleaf dependencies:
```bash
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
```

---

## 🛠️ Building the Kernel

### Option A: Kleaf / Bazel Build (Recommended)

> **Note:** In Kleaf, distribution targets (`*_dist`) are executable installer rules. Use `tools/bazel run` to build and populate the `out/.../dist/` directory. Running `tools/bazel build` only compiles artifacts into `bazel-bin/` without copying them to `out/`.

1. **OnePlus Nord 3 (vitamin) Release Distribution:**
   Builds the kernel Image, SoC base DTB (`mt6983.dtb`), board overlay DTBO (`oplus6983_22823.dtbo`), and kernel modules:
   ```bash
   tools/bazel run --config=fast //common:vitamin_dist
   ```
   Artifacts are output to `out/vitamin/dist/`.

2. **OnePlus Nord 3 (vitamin) Debug Diagnostic Distribution:**
   Builds with verbose earlycon, ftrace, boottime tracing, and ramoops:
   ```bash
   tools/bazel run --config=fast //common:vitamin_debug_dist
   ```
   Artifacts are output to `out/vitamin_debug/dist/`.

3. **Generic Kernel Image (GKI) Only:**
   ```bash
   tools/bazel run --config=fast //common:kernel_aarch64_dist
   ```
   Artifacts are output to `out/kernel_aarch64/dist/`.

---

### Option B: Standalone Clang / Make Build

For standalone development outside Bazel:
```bash
export ARCH=arm64
export SUBARCH=arm64
export LLVM=1
export LLVM_IAS=1
export CROSS_COMPILE=aarch64-linux-gnu-

export KERNEL_DIR=common
export OUT_DIR=${KERNEL_DIR}/out/ack-6.18
export DIST_DIR=${OUT_DIR}/dist
mkdir -p ${OUT_DIR} ${DIST_DIR}

cd ${KERNEL_DIR}

# Generate config
make O=${OUT_DIR} gki_defconfig
${KERNEL_DIR}/scripts/kconfig/merge_config.sh -m -O ${OUT_DIR} \
    ${OUT_DIR}/.config \
    ${KERNEL_DIR}/arch/arm64/configs/vitamin_gki.fragment
make O=${OUT_DIR} olddefconfig

# Compile
make -j$(nproc) O=${OUT_DIR} Image mediatek/mt6983.dtb mediatek/oplus6983_22823.dtbo modules

# Stage outputs
cp ${OUT_DIR}/arch/arm64/boot/Image ${DIST_DIR}/
cp ${OUT_DIR}/arch/arm64/boot/dts/mediatek/mt6983.dtb ${DIST_DIR}/
cp ${OUT_DIR}/arch/arm64/boot/dts/mediatek/oplus6983_22823.dtbo ${DIST_DIR}/
```

---

## 📦 Output Artifacts & Modules Helper

To copy build outputs and sync kernel `.ko` modules to a target directory, use the included helper script:
```bash
./copy_modules.sh
```
