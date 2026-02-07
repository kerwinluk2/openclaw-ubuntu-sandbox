#!/usr/bin/env bash
set -e

# Ensure proper ownership of OpenClaw workspace
if id sandbox >/dev/null 2>&1; then
  sudo chown -R sandbox:sandbox /home/sandbox/.openclaw || true
  sudo chown -R sandbox:sandbox /home/sandbox/.npm || true
fi

# Set up OpenClaw config directory if it doesn't exist
mkdir -p /home/sandbox/.openclaw/workspace

# Ensure Playwright browsers are accessible
export PLAYWRIGHT_BROWSERS_PATH=0

# Execute the main process (supervisord by default)
exec "$@"
