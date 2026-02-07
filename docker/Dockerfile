FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Base system, minimal desktop, and tooling.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl wget gnupg tzdata locales \
      tini sudo gosu supervisor \
      xfce4 xfce4-terminal \
      x11vnc xvfb \
      websockify novnc \
      less vim-tiny procps \
      unattended-upgrades \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Non-root user for the desktop and OpenClaw.
RUN useradd -m -s /bin/bash sandbox && \
    echo "sandbox ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-sandbox && \
    chmod 440 /etc/sudoers.d/90-sandbox

# Workspace and logs.
RUN mkdir -p /opt/novnc /opt/openclaw /var/log/supervisor
WORKDIR /opt/openclaw

# Supervisor configuration and entrypoint.
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# noVNC web UI on 8080.
EXPOSE 8080

# Drop to non-root by default.
USER sandbox

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
