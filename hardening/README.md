# Hardening notes

This directory contains optional, advanced hardening configuration for the
sandbox.

- `seccomp-profile.json` (optional): a custom seccomp profile you can enable in
  `docker/docker-compose.yml` once tuned.

By default the sandbox uses Docker's default seccomp profile, along with:

- Non-root user execution.
- Dropped capabilities.
- Read-only root filesystem.
- `no-new-privileges`.

These measures already provide a strong baseline without needing a custom
seccomp profile.
