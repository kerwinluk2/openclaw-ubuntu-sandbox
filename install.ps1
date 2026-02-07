#
# OpenClaw Ubuntu Sandbox - Windows PowerShell Installer
# One-line setup for OpenClaw Desktop Sandbox on Docker for Windows
#
# Usage:
#   irm https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.ps1 | iex
#

param(
    [string]$InstallDir = "$env:USERPROFILE\openclaw-sandbox"
)

$ErrorActionPreference = "Stop"

$RepoUrl   = "https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git"
$ComposeCmd = ""

function Write-Step($msg)    { Write-Host "`n▶ $msg" -ForegroundColor Blue }
function Write-Ok($msg)      { Write-Host "✓ $msg"  -ForegroundColor Green }
function Write-Fail($msg)    { Write-Host "✗ $msg"  -ForegroundColor Red }
function Write-Warn($msg)    { Write-Host "⚠ $msg"  -ForegroundColor Yellow }

function Test-Command($name) {
    try { Get-Command $name -ErrorAction Stop | Out-Null; return $true }
    catch { return $false }
}

Write-Step "Checking prerequisites..."

if (-not (Test-Command docker)) {
    Write-Fail "docker not found"
    Write-Host "Install Docker Desktop: https://docs.docker.com/desktop/install/windows-install/" -ForegroundColor Yellow
    exit 1
}
Write-Ok "docker found"

if (docker compose version 2>$null) {
    Write-Ok "Docker Compose plugin found"
    $ComposeCmd = "docker compose"
} elseif (Test-Command docker-compose) {
    Write-Ok "docker-compose (standalone) found"
    $ComposeCmd = "docker-compose"
} else {
    Write-Fail "Docker Compose not found"
    exit 1
}

try {
    docker info 2>$null | Out-Null
    Write-Ok "Docker is running"
} catch {
    Write-Fail "Docker is not running"
    Write-Host "Start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

Write-Step "Setting up installation directory at $InstallDir..."
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Set-Location $InstallDir
Write-Ok "Directory ready"

# Clone or update repo
if (Test-Path ".git") {
    Write-Ok "Existing repo found, updating..."
    git pull --ff-only 2>$null | Out-Null
} else {
    if (-not (Test-Command git)) {
        Write-Fail "git not found"
        Write-Host "Install git or clone the repo manually: $RepoUrl" -ForegroundColor Yellow
        exit 1
    }
    git clone $RepoUrl . | Out-Null
    Write-Ok "Cloned repository"
}

# Build and start
Write-Step "Building Docker image (first time may take a while)..."
Set-Location "$InstallDir\docker"
& $ComposeCmd build

Write-Step "Starting openclaw-sandbox container..."
& $ComposeCmd up -d

Write-Ok "Sandbox is running!"

Write-Host ""
Write-Host "Desktop (noVNC):   http://localhost:8080" -ForegroundColor Cyan
Write-Host "OpenClaw ports:    18789, 18790 (inside container)" -ForegroundColor Cyan
Write-Host "Install directory: $InstallDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Stop:    cd `"$InstallDir\docker`" && $ComposeCmd down" -ForegroundColor White
Write-Host "Start:   cd `"$InstallDir\docker`" && $ComposeCmd up -d" -ForegroundColor White
Write-Host ""
