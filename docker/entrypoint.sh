#!/usr/bin/env bash
set -e

# Ensure ownership of the OpenClaw workspace.
if id sandbox >/dev/null 2>&1; then
  chown -R sandbox:sandbox /opt/openclaw || true
fi

# Execute the main process (supervisord by default).
exec "$@"
