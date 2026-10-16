FROM ubuntu:24.04 AS base

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    sudo \
    git \
    curl \
    wget \
    build-essential \
    zip \
    unzip \
    stow \
    ripgrep \
    fd-find \
    fzf \
    nodejs \
    npm \
    tmux \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

RUN npm install -g \
    yarn \
    typescript \
    typescript-language-server \
    @vue/language-server \
    vscode-langservers-extracted

# Create a non-root user (optional)
RUN useradd -m -s /bin/bash developer \
    && mkdir -p /etc/sudoers.d \
    && echo 'developer ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/developer \
    && chmod 0440 /etc/sudoers.d/developer

# Switch to that user
USER developer
WORKDIR /home/developer

# Create .config directory
RUN mkdir -p ~/.config

# Copy dotfiles (you can bind mount instead)
COPY --chown=developer:developer . /home/developer/.dotfiles

# Link dotfiles and bootstrap plugins
RUN cd ~/.dotfiles && ./dot nvim-install && ./dot apply

FROM base AS verify

COPY --chown=developer:developer . /home/developer/.dotfiles
RUN cd ~/.dotfiles && ./dot install --dry-run
RUN cd ~/.dotfiles && ./dot apply
RUN test -x /home/developer/.tmux/plugins/tpm/tpm
RUN nvim --headless -i NONE -S /home/developer/.dotfiles/scripts/verify-nvim.lua

FROM base AS dev

# Set up default shell
ENV SHELL=/bin/bash

CMD ["/bin/bash"]
