# OpenClaw Ubuntu Sandbox with Desktop
# Hardened Ubuntu base with Node.js, OpenClaw, OpenCode AI, and browser automation
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    NODE_VERSION=22.x

# Install base system, Node.js, desktop environment, and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      # System basics
      ca-certificates curl wget gnupg tzdata locales \
      tini sudo gosu supervisor \
      # PHP & Utilities (Pre-installed for Agent)
      # Added extensions for Laravel support: bcmath, mysql, sqlite3
      php-cli php-curl php-mbstring php-xml php-zip php-bcmath php-mysql php-sqlite3 unzip \
      # Desktop & VNC
      xfce4 xfce4-terminal \
      x11vnc xvfb \
      websockify novnc \
      # Node.js and build tools
      git \
      python3 python3-pip \
      jq \
      socat \
      # Chromium for browser automation
      chromium-browser \
      fonts-liberation \
      fonts-noto-cjk \
      fonts-noto-color-emoji \
      # REQUIRED SHARED LIBRARIES (Fixes Exit 127)
      libgbm1 libasound2 libnss3 libxss1 libatk-bridge2.0-0 libgtk-3-0 \
      # Dev tools
      less vim-tiny procps \
      build-essential \
      # Security updates
      unattended-upgrades \
    # Install Node.js
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    # Install Composer globally for Laravel
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Update npm to latest
RUN npm install -g npm@latest

# Install OpenClaw and OpenCode AI globally
RUN npm install -g openclaw@2026.2.3 opencode-ai@latest

# Create non-root user with proper home directory
RUN useradd -m -s /bin/bash sandbox && \
    mkdir -p /home/sandbox/.openclaw/workspace && \
    chown -R sandbox:sandbox /home/sandbox && \
    echo "sandbox ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-sandbox && \
    chmod 440 /etc/sudoers.d/90-sandbox

# Install AIClient-2-API
WORKDIR /opt
RUN git clone https://github.com/justlovemaki/AIClient-2-API.git aiclient \
    && cd aiclient \
    && npm install \
    && chown -R sandbox:sandbox /opt/aiclient

# Install Playwright and Chromium for browser automation
RUN npm install -g playwright && npx playwright install chromium

# Install playwright-extra and stealth plugins
RUN npm install -g playwright-extra puppeteer-extra-plugin-stealth

# Install bird (additional utility)
RUN npm install -g @steipete/bird

# Create workspace and logs directories
RUN mkdir -p /opt/novnc /opt/openclaw /var/log/supervisor
WORKDIR /opt/openclaw

# Copy configuration files
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports: 8080 (noVNC), 18789/18790 (OpenClaw), 3000 (AIClient)
EXPOSE 8080 18789 18790 3000

# NOTE: We run supervisord as root, but all application programs
# (xvfb, x11vnc, novnc, openclaw, opencode, aiclient) run as the
# non-root 'sandbox' user via the 'user=' setting in supervisord.conf.
# This allows proper privilege dropping while keeping logging working.

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
