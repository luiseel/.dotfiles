FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools
RUN apt-get update && apt-get install -y \
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
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Install Neovim stable (v0.11.6)
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-arm64.tar.gz \
    && tar -C /opt -xzf nvim-linux-arm64.tar.gz \
    && rm nvim-linux-arm64.tar.gz \
    && ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim

# Create a non-root user (optional)
RUN useradd -m -s /bin/bash developer

# Switch to that user
USER developer
WORKDIR /home/developer

# Create .config directory
RUN mkdir -p ~/.config

# Copy dotfiles (you can bind mount instead)
COPY --chown=developer:developer . /home/developer/.dotfiles

# Stow the dotfiles
RUN cd ~/.dotfiles && stow --no-folding -t ~ nvim tmux

# Note: neovim plugins will install automatically on first run
# We skip installing during build because lazy.nvim configs may
# reference unloaded plugins, causing errors in headless mode

# Set up default shell
ENV SHELL=/bin/bash

CMD ["/bin/bash"]
