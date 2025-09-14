
# ---------- 1) Base GUI environment (Alpine-based) ----------
FROM lscr.io/linuxserver/webtop:ubuntu-xfce AS runtime


# ---------- 3) Combine into final image ----------
FROM runtime

USER root

# Base tools & AppImage/FUSE support on Ubuntu
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl \
      fuse3 libfuse2 \
      coreutils xz-utils file wget \
      libnss3 libasound2t64 libgbm1 libgtk-3-0 libxss1 libxtst6 libnotify4 \
    && rm -rf /var/lib/apt/lists/*

# Allow FUSE passthrough (helps when running with --device /dev/fuse)
RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf || true

# 3c) LM Studio (download only; you’ll launch it later from the desktop)
ARG LMSTUDIO_URL="https://installers.lmstudio.ai/linux/x64/0.3.25-2/LM-Studio-0.3.25-2-x64.AppImage"
RUN mkdir -p /opt/lmstudio
COPY LM-Studio-0.3.25-2-x64.AppImage /opt/lmstudio/LM-Studio.AppImage

# ensure /config exists for webtop init
RUN mkdir -p /config

USER root

# Put the AppImage in place (you already copy it)
# Ensure it’s executable, then extract it
RUN chmod +x /opt/lmstudio/LM-Studio.AppImage \
 && cd /opt/lmstudio

# Wrapper that disables the Electron sandbox (needed in most containers)
RUN printf '%s\n' '#!/bin/sh' \
    'exec /opt/lmstudio/LM-Studio.AppImage' \
    > /usr/local/bin/lmstudio && chmod +x /usr/local/bin/lmstudio

# Helpful envs for Electron/Wayland/X11 inside webtop
ENV ELECTRON_OZONE_PLATFORM_HINT=auto \
    XDG_RUNTIME_DIR=/tmp

# ---- Node (LTS) via nvm ----
USER root
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p "${NVM_DIR}" \
 && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
 # Use single quotes for the whole bash -lc string; double quotes inside
 && /bin/bash -lc 'source "$NVM_DIR/nvm.sh" \
    && nvm install --lts \
    && nvm alias default "lts/*" \
    && nvm use default \
    && corepack enable \
    # Symlink Node/npm/npx to a fixed path so PATH is static (no $(...) in ENV)
    && ln -sf "$(nvm which current)" /usr/local/bin/node \
    && ln -sf "$(dirname "$(nvm which current)")/npm" /usr/local/bin/npm \
    && ln -sf "$(dirname "$(nvm which current)")/npx" /usr/local/bin/npx \
    && ln -sf "$(dirname "$(nvm which current)")/corepack" /usr/local/bin/corepack'
# (No ENV with command substitution needed)

# Make nvm available in interactive shells too (optional quality-of-life)
RUN printf '%s\n' \
  'export NVM_DIR="/usr/local/nvm"' \
  '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' \
  '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"' \
  > /etc/profile.d/nvm.sh

# 1) Build deps for Python
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential curl ca-certificates git \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev \
    libncursesw5-dev libgdbm-dev liblzma-dev tk-dev uuid-dev xz-utils nano \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config/Desktop && \
    ln -s /opt/lmstudio /config/Desktop/lmstudio

# Expose the three services
EXPOSE 3000 8080 3333 3001

# Webtop uses s6-overlay; keep JSON form to avoid the linter warning
ENTRYPOINT ["/init"]
