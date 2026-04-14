FROM ubuntu:24.04 AS base

ARG TARGETARCH

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

# Install Neovim stable (v0.11.7)
RUN case "$TARGETARCH" in \
      amd64) nvim_arch="x86_64" ;; \
      arm64) nvim_arch="arm64" ;; \
      *) echo "Unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
    esac \
    && curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-${nvim_arch}.tar.gz" \
    && tar -C /opt -xzf "nvim-linux-${nvim_arch}.tar.gz" \
    && rm "nvim-linux-${nvim_arch}.tar.gz" \
    && ln -s "/opt/nvim-linux-${nvim_arch}/bin/nvim" /usr/local/bin/nvim

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
RUN cd ~/.dotfiles && ./dot apply

FROM base AS verify

COPY --chown=developer:developer . /home/developer/.dotfiles
RUN cd ~/.dotfiles && ./dot install --dry-run
RUN cd ~/.dotfiles && ./dot apply
RUN test -x /home/developer/.tmux/plugins/tpm/tpm
RUN XDG_STATE_HOME=/tmp/nvim-state XDG_CACHE_HOME=/tmp/nvim-cache \
    nvim --headless -i NONE \
    '+lua dofile("/home/developer/.config/nvim/init.lua"); assert(not vim.tbl_contains(vim.lsp.config.ts_ls.filetypes, "vue"), "ts_ls should not attach to vue"); assert(vim.tbl_contains(vim.lsp.config.vue_ls.filetypes, "vue"), "vue_ls must attach to vue")' \
    +qa

FROM base AS dev

# Set up default shell
ENV SHELL=/bin/bash

CMD ["/bin/bash"]
