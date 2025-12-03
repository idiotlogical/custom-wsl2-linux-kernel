# Custom WSL2 Linux Kernel

This repository is forked from the excellent [Windows WSL2 Kernel Build Script
repo by
slyfox1186](https://github.com/slyfox1186/windows-wsl2-kernel-build-script).

This project aims to use GitHub Actions Workflows to produce and publish
up-to-date, versioned custom builds of
[WSL2-Linux-Kernel](https://github.com/microsoft/WSL2-Linux-Kernel) with
[`HIDDEV`](https://docs.kernel.org/hid/hiddev.html) and
[`HIDRAW`](https://docs.kernel.org/hid/hidraw.html) enabled.

These custom kernels builds can be used to enable full Yubikey passthrough to
WSL2 using [`usbipd`](https://github.com/dorssel/usbipd-win), with full FIDO2
functionality.

The versioning scheme of this project matches the versioning scheme used by
WSL2-Linux-Kernel.

## Usage

- Download the custom kernel from the releases page
- Make sure you have saved all your work in all WSL2 instances
- Shutdown all WSL2 instances with `wsl --shutdown`
- Edit (or create) the ~/.wslconfig file on Windows
- Specify the path to the custom kernel

```ini
# For example...
[wsl2]
kernel=C:\\Users\\YOUR_USERNAME\\Downloads\\vmlinux
```

- Start a WSL2 instance
- Check that the kernel is running with `uname -sr`

```
Linux 5.15.123.1-lgug2z-custom-WSL2
```

## Modification

If you want to build and publish your own custom WSL2 Linux Kernel, you can
fork this repository and make whatever configuration modifications in
[config-wsl](config-wsl). The [GitHub Actions
Workflow](.github/workflows/build.yml) will take care of the rest.

Please take care to update `CONFIG_LOCALVERSION` to distinguish your custom
kernel from this one.

## Enabling HFS+ in builds

This repository includes a small kernel config fragment and helper scripts to
enable HFS+ support in the kernel build. The fragment enables the HFS+ driver
as a module (`CONFIG_HFSPLUS_FS=m`). Files added:

- `kernel-config-fragments/hfsplus.cfg` — the config fragment containing
  `CONFIG_HFSPLUS_FS=m`.
- `scripts/enable-hfsplus.sh` — Linux shell helper to apply the fragment to
  your kernel `.config` (uses `scripts/config` if available, otherwise edits
  `.config` directly).
- `scripts/enable-hfsplus.ps1` — PowerShell helper for Windows users.

Usage (from the kernel source root where `.config` is located):

Linux (bash):

```bash
# recommend running inside your kernel source tree
./scripts/enable-hfsplus.sh
make olddefconfig  # update any dependent options
make -j$(nproc)
```

Windows PowerShell (when working with WSL or a Git-managed kernel tree):

```powershell
.
\scripts\enable-hfsplus.ps1
# then run make inside WSL or your Linux build environment
```

If you prefer to manually add the option, append `CONFIG_HFSPLUS_FS=m` to your
`.config` and run `make olddefconfig` before building.

Note: This repository does not contain the kernel source itself; you must run
these scripts inside a WSL/Linux kernel source tree (for example, a local
clone of `microsoft/WSL2-Linux-Kernel` or when using the build workflow from
this repo). Enabling HFS+ as a module keeps the kernel smaller and allows the
filesystem driver to be loaded only when needed.
