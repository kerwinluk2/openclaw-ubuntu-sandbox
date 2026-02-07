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

# Check docker
step "Checking prerequisites..."

if ! command -v docker >/dev/null 2>&1; then
  fail "docker not found"
  echo "Install Docker: https://docs.docker.com/get-docker/"
  exit 1
fi
ok "docker found"

# Check docker compose
if docker compose version >/dev/null 2>&1; then
  ok "docker compose plugin found"
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  ok "docker-compose (standalone) found"
  COMPOSE_CMD="docker-compose"
else
  fail "Docker Compose not found"
  echo "Install Docker Compose: https://docs.docker.com/compose/install/"
  exit 1
fi

# Check docker daemon
if ! docker info >/dev/null 2>&1; then
  fail "Docker is not running or you don't have permission"
  echo "Start Docker and ensure your user can run 'docker info'."
  exit 1
fi
ok "Docker is running"

# Clone or update repo
step "Preparing installation directory at ${INSTALL_DIR}..."
mkdir -p "$(dirname "$INSTALL_DIR")"

if [ -d "$INSTALL_DIR/.git" ]; then
  ok "Existing repo found, updating..."
  cd "$INSTALL_DIR"
  git pull --ff-only || warn "git pull failed, continuing with existing checkout"
else
  if ! command -v git >/dev/null 2>&1; then
    fail "git not found, required for clone"
    echo "Install git or manually clone the repo:"
    echo "  git clone $REPO_URL $INSTALL_DIR"
    exit 1
  fi

  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
  ok "Cloned repository"
fi

# Build and start
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
