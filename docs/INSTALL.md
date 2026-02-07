# INSTALL

This document describes how to build and run the hardened Ubuntu desktop sandbox
for OpenClaw.

## Prerequisites

- A modern Linux host with Docker Engine and Docker Compose plugin installed.
- Ports and firewall rules allowing access to TCP port 8080 from your client.

## Quick start

1. Clone this repository:

   ```bash
   git clone https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git
   cd openclaw-ubuntu-sandbox/docker
   ```

2. Build the image:

   ```bash
   docker compose build
   ```

3. Start the sandbox in the background:

   ```bash
   docker compose up -d
   ```

4. From your browser, open:

   - `http://<host-ip>:8080` to access the XFCE desktop via noVNC.

5. To stop the sandbox:

   ```bash
   docker compose down
   ```

## Integrating OpenClaw

By default the container expects an executable `start-openclaw.sh` in
`/opt/openclaw` (inside the container) that starts OpenClaw or any related
services.

A typical workflow is:

1. Place your OpenClaw files in the `data/` directory on the host.
2. Add or adjust `start-openclaw.sh` to launch OpenClaw from `/opt/openclaw/data`.
3. Rebuild the image or mount additional volumes as needed.

The sandbox is designed so that only `./data` on the host becomes writable
storage in the container.
