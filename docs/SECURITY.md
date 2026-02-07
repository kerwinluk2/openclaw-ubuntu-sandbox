# SECURITY

This document describes the main hardening measures used by the sandbox and how
they affect the threat model.

## Threat model

The sandbox is designed to:

- Contain OpenClaw and its tooling inside a non-root desktop session.
- Reduce the ability of code inside the container to modify the host.
- Make persistence and lateral movement harder if OpenClaw is compromised.

It does **not** attempt to withstand a malicious Docker daemon, kernel-level
exploits, or physical access to the host.

## Hardening measures

- **Non-root user**: The desktop and OpenClaw run as the `sandbox` user, not as
  root inside the container.
- **Dropped capabilities**: All Linux capabilities are dropped via
  `cap_drop: ["ALL"]`. Add back capabilities only if strictly required.
- **No new privileges**: `no-new-privileges` is enabled to prevent privilege
  escalation via `setuid` binaries or similar mechanisms.
- **Read-only root filesystem**: The container root filesystem is mounted as
  read-only (`read_only: true`), with only specific writable paths (tmpfs and
  the `data` volume).
- **Limited writable storage**: Only `./data` on the host is writable inside the
  container (`/opt/openclaw/data`). This reduces the impact of arbitrary file
  writes.
- **Resource limits**: Optional CPU and memory limits are configured to avoid
  the sandbox consuming the entire host.

## Seccomp profile

Docker applies its default seccomp profile by default, which already blocks
many high-risk syscalls.

You can add a custom profile by:

1. Creating `hardening/seccomp-profile.json` based on the default Docker
   seccomp profile.
2. Uncommenting the `seccomp:./hardening/seccomp-profile.json` line in
   `docker/docker-compose.yml`.

Be prepared to iterate on this profile, as a too-strict configuration will
prevent OpenClaw from starting.

## Network isolation

By default the sandbox binds only port 8080 to the host. You can further
restrict network access by:

- Using an internal Docker network and exposing the sandbox only via a reverse
  proxy.
- Applying host-level firewall rules to limit which clients can reach port
  8080.

## Updating the sandbox

When updating OpenClaw or the base image:

- Rebuild with `docker compose build` to incorporate security updates.
- Periodically review `docs/SECURITY.md` and your Docker configuration against
  current best practices.
