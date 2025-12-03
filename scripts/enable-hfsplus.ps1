# PowerShell helper to set CONFIG_HFSPLUS_FS in a kernel .config file
# Usage: Run from the kernel source root where .config exists.
param()

$kconf = Join-Path -Path (Get-Location) -ChildPath '.config'
if (-not (Test-Path $kconf)) {
    Write-Error ".config not found. Run from the kernel source directory."; exit 1
}

$content = Get-Content $kconf -Raw
if ($content -match '^(?m)CONFIG_HFSPLUS_FS=') {
    $content = $content -replace '^(?m)CONFIG_HFSPLUS_FS=.*', 'CONFIG_HFSPLUS_FS=m'
} else {
    $content += "`nCONFIG_HFSPLUS_FS=m`n"
}

Set-Content -Path $kconf -Value $content -Encoding UTF8
Write-Output "Applied CONFIG_HFSPLUS_FS=m to $kconf. Run 'make olddefconfig' and then 'make' to build." 
