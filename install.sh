#!/usr/bin/env bash
# One-line installer for openclaw-ubuntu-sandbox (Linux/macOS)
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.sh)

set -e

INSTALL_DIR="${OPENCLAW_SANDBOX_DIR:-$HOME/openclaw-sandbox}"
REPO_URL="https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

step()   { echo -e "\n${BLUE}▶${NC} $1"; }
ok()     { echo -e "${GREEN}✓${NC} $1"; }
warn()   { echo -e "${YELLOW}⚠${NC} $1"; }
fail()   { echo -e "${RED}✗${NC} $1"; }

# Check for root/sudo capability helper
can_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0
    fi
    if command -v sudo >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Install Git if missing
install_git() {
    if command -v git >/dev/null 2>&1; then
        return 0
    fi
    step "Git not found. Attempting to install..."
    
    if ! can_sudo; then
        fail "Cannot install git (no root/sudo). Please install git manually."
        exit 1
    fi

    if [ "$(id -u)" -ne 0 ]; then SUDO="sudo"; else SUDO=""; fi

    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update && $SUDO apt-get install -y git
    elif command -v yum >/dev/null 2>&1; then
        $SUDO yum install -y git
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y git
    elif command -v apk >/dev/null 2>&1; then
        $SUDO apk add git
    else
        fail "Unsupported package manager. Please install git manually."
        exit 1
    fi
    ok "Git installed"
}

# Install Docker if missing
install_docker() {
    if command -v docker >/dev/null 2>&1; then
        ok "docker found"
        return 0
    fi

    step "Docker not found. Attempting automatic installation..."
    
    # We need root permissions to install Docker
    if ! can_sudo; then
        fail "Cannot install Docker automatically (no root/sudo). Please install Docker manually: https://docs.docker.com/get-docker/"
        exit 1
    fi

    warn "This will download and run the official Docker install script (https://get.docker.com)"
    warn "Waiting 3 seconds... (Ctrl+C to cancel)"
    sleep 3

    if curl -fsSL https://get.docker.com | sh; then
        ok "Docker installed successfully"
        
        # Add current user to docker group if not root
        if [ "$(id -u)" -ne 0 ]; then
            step "Adding user '$USER' to 'docker' group..."
            sudo usermod -aG docker "$USER"
            warn "You have been added to the 'docker' group."
            warn "Please LOG OUT and LOG BACK IN for this to take effect."
            warn "Then run this installer script again."
            exit 0
        fi
    else
        fail "Docker installation failed."
        exit 1
    fi
}

# 1. Check/Install Prerequisites
step "Checking prerequisites..."
install_git
install_docker

# 2. Check Docker Compose
if docker compose version >/dev/null 2>&1; then
  ok "docker compose plugin found"
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  ok "docker-compose (standalone) found"
  COMPOSE_CMD="docker-compose"
else
  # Docker Desktop/modern installs usually include the plugin, but just in case
  fail "Docker Compose not found. Please install the Docker Compose plugin."
  exit 1
fi

# 3. Check Docker Daemon
if ! docker info >/dev/null 2>&1; then
  fail "Docker daemon is not running or you don't have permission."
  
  if [ "$(id -u)" -ne 0 ]; then
      echo "Try running: sudo usermod -aG docker $USER"
      echo "Then log out and back in."
  else
      echo "Try starting the service: systemctl start docker"
  fi
  exit 1
fi
ok "Docker daemon is running"

# 4. Clone or update repo
step "Preparing installation directory at ${INSTALL_DIR}..."
mkdir -p "$(dirname "$INSTALL_DIR")"

if [ -d "$INSTALL_DIR/.git" ]; then
  ok "Existing repo found, updating..."
  cd "$INSTALL_DIR"
  git pull --ff-only || warn "git pull failed, continuing with existing checkout"
else
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
  ok "Cloned repository"
fi

# 5. Build and start
step "Building Docker image (this may take a while on first run)..."
cd docker
$COMPOSE_CMD build

step "Starting openclaw-sandbox container..."
$COMPOSE_CMD up -d

ok "Sandbox is running!"

echo
echo "Desktop (noVNC):   http://localhost:8080"
echo "OpenClaw ports:    18789, 18790 (from inside the container)"
echo "Install directory: $INSTALL_DIR"
echo
echo "To stop:    cd \"$INSTALL_DIR/docker\" && $COMPOSE_CMD down"
echo "To start:   cd \"$INSTALL_DIR/docker\" && $COMPOSE_CMD up -d"
echo
echo "-------------------------------------------------------"
echo "⚠️  SECURITY NOTICE: DIRECT ACCESS IS BLOCKED BY DEFAULT"
echo "To access this from your local computer, run this command in a NEW terminal on your PC:"
echo ""
echo "   ssh -L 8080:127.0.0.1:8080 root@\$(curl -s ifconfig.me || echo \"<YOUR_VPS_IP>\")"
echo ""
echo "Then open http://localhost:8080 in your browser."
echo "-------------------------------------------------------"
echo
