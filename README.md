<div align="center">
  <h1>⚡ MT6983 Kernel Source ⚡</h1>
  <p><strong>Kernel Build Manifest for MT6983 </strong></p>
</div>

---

## 🚀 Getting Started

Follow these streamlined instructions to initialize your workspace, sync the source tree, and compile the kernel.

### 📦 1. Initialize Workspace
Set up your local repository using the kernel manifest:
```bash
repo init -u https://github.com/mt6983-development/kernel_manifest.git --depth=1
```

### 🔄 2. Sync Source & Compile Kernel
​Fetch the source code efficiently (skipping unnecessary tags and clone bundles) and immediately kick off the build process with Thin LTO enabled for highly optimized performance:
```bash
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
```

### Start the kernel build
```bash
LTO=thin build/build.sh -j$(nproc --all)
```

### To copy those kernel output can use this script
```bash
wget https://raw.githubusercontent.com/mt6983-development/kernel_manifest/main/copy_modules.sh && chmod +x copy_modules.sh
```

### Script Usage
```bash
./copy_modules.sh
```
