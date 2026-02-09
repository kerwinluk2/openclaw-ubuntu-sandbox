#!/usr/bin/env bash
set -e

# Helper to fix permissions on mounted volumes if they differ from sandbox user
fix_perms() {
    local dir="$1"
    # Only try to chown if directory exists
    if [ -d "$dir" ]; then
        chown -R sandbox:sandbox "$dir" || true
    fi
}

# Fix ownership of persistent data directories
# This ensures that even if docker creates them as root on the host, 
# the sandbox user can write to them.
if id sandbox >/dev/null 2>&1; then
    fix_perms "/home/sandbox/.openclaw/workspace"
    fix_perms "/home/sandbox/.npm"
    fix_perms "/home/sandbox/.config"
    fix_perms "/home/sandbox/.cache"
    fix_perms "/home/sandbox/.ssh"
    fix_perms "/var/log/supervisor"
fi

# Set up Playwright
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Execute the main process (supervisord by default)
exec "$@"
