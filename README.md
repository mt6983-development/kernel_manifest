<div align="center">
  <h1>⚡ MT6983 Kernel Source ⚡</h1>
  <p><strong>Kernel Build Manifest for OnePlus Nord 3 5G (vitamin / MT6983)</strong></p>
</div>

---

## 🚀 Getting Started

Follow these instructions to initialize your workspace, sync the source tree, and compile the kernel.

### 📦 1. Initialize Workspace
Set up your local repository using the kernel manifest:

**For Linux 6.1 (ACK android14-6.1, `port-6.1.176` / default):**
```bash
repo init -u https://github.com/mt6983-development/kernel_manifest.git -b main --depth=1
```
*(or explicitly specify `-b port-6.1.176`)*

**For Linux 5.10 vendor legacy (`lineage-24.0`):**
```bash
repo init -u https://github.com/mt6983-development/kernel_manifest.git -b lineage-24.0 --depth=1
```

### 🔄 2. Sync Source & Compile Kernel
Fetch the source code efficiently:
```bash
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
```

### 🔨 3. Start the Kernel Build
Kick off the kernel and vendor modules build with Thin LTO enabled:
```bash
LTO=thin build/build.sh -j$(nproc --all)
```

### 📥 4. Copy Kernel Artifacts & Modules
To copy compiled kernel artifacts (`Image.gz`, `mt6983.dtb`, `oplus6983_22823.dtbo`, and `.ko` modules) into your device tree:
```bash
wget https://raw.githubusercontent.com/mt6983-development/kernel_manifest/main/copy_modules.sh && chmod +x copy_modules.sh
./copy_modules.sh
```
