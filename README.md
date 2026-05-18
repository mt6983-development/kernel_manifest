## Repo Init ##
```bash
repo init -u https://github.com/mt6983-development/kernel_manifest.git --depth=1
```
## Sync Source ##
```bash
repo sync --force-sync --no-clone-bundle --current-branch --no-tags -j$(nproc --all)
```
## Start building ##
```bash
LTO=thin build/build.sh -j$(nproc --all)
```
## To copy those kernel output can use this script ##
```bash
wget https://raw.githubusercontent.com/mt6983-development/kernel_manifest/main/copy_modules.sh
```
