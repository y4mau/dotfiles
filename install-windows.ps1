#Requires -Version 5.1
<#
.SYNOPSIS
    Set up dotfiles symlinks for Windows (Claude Code config via WSL).

.DESCRIPTION
    Creates symlinks in $env:USERPROFILE\.claude\ pointing to the dotfiles
    repository on WSL via \\wsl.localhost\<distro>\... UNC paths.

    Prerequisites:
      - WSL must be installed and running
      - Either Developer Mode enabled OR run as Administrator

.PARAMETER WslDistro
    WSL distribution name. Auto-detected if not specified.

.PARAMETER DotfilesPath
    Path to dotfiles inside WSL. Defaults to home/y4mau/ghq/github.com/y4mau/dotfiles.

.EXAMPLE
    .\install-windows.ps1
    .\install-windows.ps1 -WslDistro "Ubuntu-24.04"
#>
[CmdletBinding()]
param(
    [string]$WslDistro,
    [string]$DotfilesPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---- Helper functions --------------------------------------------------------

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Test-SymlinkCapability {
    $testLink = Join-Path $env:TEMP "symlink_test_$(Get-Random)"
    $testTarget = Join-Path $env:TEMP "symlink_target_$(Get-Random)"
    try {
        New-Item -ItemType File -Path $testTarget -Force | Out-Null
        New-Item -ItemType SymbolicLink -Path $testLink -Target $testTarget -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
    finally {
        Remove-Item -Path $testLink -ErrorAction SilentlyContinue
        Remove-Item -Path $testTarget -ErrorAction SilentlyContinue
    }
}

function New-SafeSymlink {
    param(
        [string]$Path,
        [string]$Target,
        [switch]$IsDirectory
    )

    if (Test-Path $Path) {
        $item = Get-Item $Path -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            Write-Info "Removing existing symlink: $Path"
            Remove-Item $Path -Force
        }
        else {
            $backupPath = "$Path.bak"
            Write-Warn "Backing up existing item: $Path -> $backupPath"
            if (Test-Path $backupPath) {
                Remove-Item $backupPath -Recurse -Force
            }
            Move-Item $Path $backupPath
        }
    }

    if ($IsDirectory) {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
    }
    Write-Info "Linked: $Path -> $Target"
}

# ---- Main --------------------------------------------------------------------

# Check symlink capability
if (-not (Test-SymlinkCapability)) {
    Write-Host ""
    Write-Host "ERROR: Cannot create symlinks." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please do one of the following:" -ForegroundColor Yellow
    Write-Host "  1. Enable Developer Mode: Settings > Privacy & Security > For developers > Developer Mode"
    Write-Host "  2. Run this script as Administrator"
    Write-Host ""
    exit 1
}

# Auto-detect WSL distro
if (-not $WslDistro) {
    Write-Info "Auto-detecting WSL distribution..."
    $distros = wsl.exe -l -q 2>$null |
        ForEach-Object { $_ -replace "`0", "" } |
        Where-Object { $_.Trim() -ne "" -and $_ -notmatch "docker" }

    if (-not $distros) {
        Write-Host "ERROR: No WSL distribution found." -ForegroundColor Red
        exit 1
    }

    $WslDistro = ($distros | Select-Object -First 1).Trim()
    Write-Info "Detected WSL distro: $WslDistro"
}

# Determine dotfiles path in WSL
if (-not $DotfilesPath) {
    $wslHome = wsl.exe -d $WslDistro -- bash -c 'echo $HOME' 2>$null |
        ForEach-Object { $_ -replace "`0", "" } |
        ForEach-Object { $_.Trim() }

    if (-not $wslHome) {
        Write-Host "ERROR: Could not determine WSL home directory." -ForegroundColor Red
        exit 1
    }

    # Remove leading / for UNC path construction
    $DotfilesPath = "$wslHome/ghq/github.com/y4mau/dotfiles" -replace "^/", ""
}

$wslBase = "\\wsl.localhost\$WslDistro\$($DotfilesPath -replace '/', '\')"
$claudeSource = "$wslBase\claude"

# Verify source exists
if (-not (Test-Path $claudeSource)) {
    Write-Host "ERROR: Dotfiles claude directory not found at: $claudeSource" -ForegroundColor Red
    Write-Host "Make sure WSL is running and the path is correct." -ForegroundColor Yellow
    exit 1
}

Write-Info "Dotfiles source: $claudeSource"

# ---- Create .claude symlinks -------------------------------------------------

$claudeDir = Join-Path $env:USERPROFILE ".claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir | Out-Null
    Write-Info "Created: $claudeDir"
}

# Files to symlink
$fileLinks = @(
    @{ Name = "CLAUDE.md"; IsDir = $false }
    @{ Name = "settings.json"; IsDir = $false }
    @{ Name = "statusline-command.sh"; IsDir = $false }
)

# Directories to symlink
$dirLinks = @(
    @{ Name = "commands"; IsDir = $true }
    @{ Name = "hooks"; IsDir = $true }
    @{ Name = "agents"; IsDir = $true }
)

$allLinks = $fileLinks + $dirLinks

foreach ($link in $allLinks) {
    $sourcePath = Join-Path $claudeSource $link.Name
    $targetPath = Join-Path $claudeDir $link.Name

    if (-not (Test-Path $sourcePath)) {
        Write-Warn "Source not found, skipping: $sourcePath"
        continue
    }

    New-SafeSymlink -Path $targetPath -Target $sourcePath -IsDirectory:$link.IsDir
}

Write-Host ""
Write-Host "Windows Claude Code symlinks set up successfully!" -ForegroundColor Green

# ---- Windows Terminal keybindings -------------------------------------------

# Pass Ctrl+] through to the shell (used by ghq+peco selector in bash/zsh)
$wtSettingsPaths = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)

foreach ($wtSettings in $wtSettingsPaths) {
    if (-not (Test-Path $wtSettings)) { continue }

    Write-Info "Updating Windows Terminal keybindings: $wtSettings"
    $settings = Get-Content $wtSettings -Raw | ConvertFrom-Json

    # Ensure keybindings array exists
    if (-not $settings.keybindings) {
        $settings | Add-Member -NotePropertyName "keybindings" -NotePropertyValue @()
    }

    # Check if Ctrl+] binding already exists
    $hasCtrlBracket = $settings.keybindings | Where-Object { $_.keys -eq "ctrl+]" }
    if (-not $hasCtrlBracket) {
        $binding = [PSCustomObject]@{
            keys    = "ctrl+]"
            command = [PSCustomObject]@{
                action = "sendInput"
                input  = "`u{001d}"
            }
        }
        $settings.keybindings += $binding
        $settings | ConvertTo-Json -Depth 10 | Set-Content $wtSettings -Encoding UTF8
        Write-Info "Added Ctrl+] passthrough for ghq+peco selector"
    }
    else {
        Write-Info "Ctrl+] keybinding already configured"
    }
}

Write-Host ""
Write-Host "Note: WSL must be running for symlinks to resolve." -ForegroundColor Yellow
Write-Host "Backed up files (if any) have .bak extension in $claudeDir" -ForegroundColor Yellow
Write-Host ""
