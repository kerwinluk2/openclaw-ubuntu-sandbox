# OpenClaw Ubuntu Sandbox

A hardened, secure Ubuntu desktop sandbox designed for running **OpenClaw** and **OpenCode AI** with full browser automation capabilities (Playwright/Chromium).

Designed for developers and automation engineers who need a safe, isolated environment that supports code development and complex browser tasks (WhatsApp, Telegram, Discord) without compromising host security.

## 🚀 Quick Start

### Linux / macOS
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.sh)
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.ps1 | iex
```

*Note: Since this is a private repository, you may need to clone it first and run `install.ps1` locally if the command above fails.*

This will:
1.  Clone (or update) this repository to `$HOME/openclaw-sandbox`.
2.  Build the hardened Docker image.
3.  Start the sandbox.

---

## ✨ Features

-   **Full Desktop Environment**: XFCE desktop accessible via web browser (noVNC) at `http://localhost:8080`.
-   **AI Automation Ready**: Pre-installed with **OpenClaw (v2026.2.3)**, **OpenCode AI**, and **Playwright**.
-   **AI Client Gateway**: Pre-installed **AIClient-2-API** accessible at `http://localhost:3000`.
-   **Laravel Ready**: Includes Composer, PHP (with bcmath, mysql, sqlite3 extensions), and Node.js 22.
-   **Browser Automation**: Optimized for Chromium automation (WhatsApp, Telegram, Discord, etc.) with shared memory tweaks and session persistence.
-   **Secure by Design**:
    -   **Non-root**: Runs entirely as user `sandbox` (UID 1000).
    -   **Read-Only Root**: The container's root filesystem is read-only.
    -   **Least Privilege**: All Linux capabilities dropped (`cap_drop: [ALL]`).
    -   **Localhost Only**: Services are bound to `127.0.0.1` by default, preventing external network access.
    -   **Isolation**: `no-new-privileges` enabled to prevent escalation.
-   **Persistent Workspace**: Keeps your projects, browser sessions (`.config`), SSH keys, and npm packages between restarts.

## 🛠️ Manual Installation

If you prefer to run it manually without the helper scripts:

```bash
# Clone into 'openclaw-sandbox' to match the automated installer
git clone https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git ~/openclaw-sandbox
cd ~/openclaw-sandbox/docker

# Build the image
docker compose build

# Start the container
docker compose up -d
```

## 📂 Documentation

-   [**Installation Guide**](docs/INSTALL.md): Detailed setup instructions and how to install OpenClaw plugins.
-   [**Security Model**](docs/SECURITY.md): Explanation of hardening measures, threat model, and trade-offs.
-   [**Hardening Details**](hardening/README.md): Custom seccomp profiles and advanced configuration.

## 🔌 Access & Ports

Services are bound to **127.0.0.1** for security. You cannot access them from other devices on your network unless you modify `docker-compose.yml` or use an SSH tunnel.

| Port | Service | URL | Description |
| :--- | :--- | :--- | :--- |
| **8080** | noVNC | `http://localhost:8080` | Web-based Desktop Access |
| **3000** | AIClient | `http://localhost:3000` | AI Client Gateway / UI |
| **18789** | OpenClaw API | `http://localhost:18789` | Main Automation Gateway |
| **18790** | OpenClaw WS | `http://localhost:18790` | WebSocket / Dashboard |

### 🔒 Secure Access (Recommended)
To access the sandbox securely from your local machine, run this SSH tunnel command in a separate terminal:
```bash
ssh -L 8080:127.0.0.1:8080 root@<YOUR_VPS_IP>
```
Then open `http://localhost:8080` in your browser.

## 🛡️ Security Note

This sandbox balances strict security with usability. While it drops all capabilities and runs read-only, it enables specific features (like shared memory and specific writable volumes) to allow modern browsers and development tools to function correctly. See [SECURITY.md](docs/SECURITY.md) for full details.
